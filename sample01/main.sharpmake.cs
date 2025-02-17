using System.IO;
using Sharpmake;

[Generate]
public class BasicsProject : Project
{
    public BasicsProject()
    {
        Name = "Basics";
        SourceRootPath = @"[project.SharpmakeCsPath]";
        AddTargets(new Target(
            Platform.win32 | Platform.win64,
            DevEnv.vs2015,
            Optimization.Debug | Optimization.Release),
        new Target(
            Platform.linux,
            DevEnv.make,
            Optimization.Debug | Optimization.Release));
    }

    [Configure]
    public void ConfigureAll(Project.Configuration conf, Target target)
    {
        conf.ProjectPath = Path.Combine("[project.SharpmakeCsPath]", "generated", "[target.Platform]", "[target.DevEnv]");
        conf.TargetPath = Path.Combine("[project.SharpmakeCsPath]", "bin", "[target.Platform]", "[target.Optimization]");
    }
}

[Generate]
public class BasicsSolution : Solution
{
    public BasicsSolution()
    {
        Name = "Basics";

        AddTargets(new Target(
            Platform.win32 | Platform.win64,
            DevEnv.vs2015,
            Optimization.Debug | Optimization.Release),
        new Target(
            Platform.linux,
            DevEnv.make,
            Optimization.Debug | Optimization.Release));
    }

    [Configure]
    public void ConfigureAll(Solution.Configuration conf, Target target)
    {
        conf.SolutionPath = Path.Combine("[solution.SharpmakeCsPath]", "generated", "[target.Platform]", "[target.DevEnv]");
        conf.AddProject<BasicsProject>(target);
    }
}

public static class Main
{
    [Sharpmake.Main]
    public static void SharpmakeMain(Sharpmake.Arguments arguments)
    {
        arguments.Generate<BasicsSolution>();
    }
}
