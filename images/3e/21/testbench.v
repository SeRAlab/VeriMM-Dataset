`timescale 1ns/1ps

module IFFT_4point_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] Xi0;
    reg [3:0] Xi1;
    reg [3:0] Xi2;
    reg [3:0] Xi3;
    reg [3:0] Xr0;
    reg [3:0] Xr1;
    reg [3:0] Xr2;
    reg [3:0] Xr3;
    wire [3:0] Yi0;
    wire [3:0] Yi1;
    wire [3:0] Yi2;
    wire [3:0] Yi3;
    wire [3:0] Yr0;
    wire [3:0] Yr1;
    wire [3:0] Yr2;
    wire [3:0] Yr3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IFFT_4point dut (
        .Xi0(Xi0),
        .Xi1(Xi1),
        .Xi2(Xi2),
        .Xi3(Xi3),
        .Xr0(Xr0),
        .Xr1(Xr1),
        .Xr2(Xr2),
        .Xr3(Xr3),
        .Yi0(Yi0),
        .Yi1(Yi1),
        .Yi2(Yi2),
        .Yi3(Yi3),
        .Yr0(Yr0),
        .Yr1(Yr1),
        .Yr2(Yr2),
        .Yr3(Yr3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: DC Signal Impulse (X0 = 4, others 0)", test_num);
            Xr0 = 4'h4; Xr1 = 4'h0; Xr2 = 4'h0; Xr3 = 4'h0;
            Xi0 = 4'h0; Xi1 = 4'h0; Xi2 = 4'h0; Xi3 = 4'h0;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h1, 4'h1, 4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Uniform Real Signal (All Xr = 4)", test_num);
            Xr0 = 4'h4; Xr1 = 4'h4; Xr2 = 4'h4; Xr3 = 4'h4;
            Xi0 = 4'h0; Xi1 = 4'h0; Xi2 = 4'h0; Xi3 = 4'h0;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h4, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Frequency Impulse Real (X1 = 4)", test_num);
            Xr0 = 4'h0; Xr1 = 4'h4; Xr2 = 4'h0; Xr3 = 4'h0;
            Xi0 = 4'h0; Xi1 = 4'h0; Xi2 = 4'h0; Xi3 = 4'h0;


            #1;



            check_outputs(4'h0, 4'h1, 4'h0, 4'hF, 4'h1, 4'h0, 4'hF, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Frequency Impulse Imaginary (Xi1 = 4)", test_num);
            Xr0 = 4'h0; Xr1 = 4'h0; Xr2 = 4'h0; Xr3 = 4'h0;
            Xi0 = 4'h0; Xi1 = 4'h4; Xi2 = 4'h0; Xi3 = 4'h0;


            #1;



            check_outputs(4'h1, 4'h0, 4'hF, 4'h0, 4'h0, 4'hF, 4'h0, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: High Frequency Real (Alternating 4, -4)", test_num);
            Xr0 = 4'h4; Xr1 = 4'hC; Xr2 = 4'h4; Xr3 = 4'hC;
            Xi0 = 4'h0; Xi1 = 4'h0; Xi2 = 4'h0; Xi3 = 4'h0;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h4, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Zero Input", test_num);
            Xr0 = 4'h0; Xr1 = 4'h0; Xr2 = 4'h0; Xr3 = 4'h0;
            Xi0 = 4'h0; Xi1 = 4'h0; Xi2 = 4'h0; Xi3 = 4'h0;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IFFT_4point Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [3:0] expected_Yi0;
        input [3:0] expected_Yi1;
        input [3:0] expected_Yi2;
        input [3:0] expected_Yi3;
        input [3:0] expected_Yr0;
        input [3:0] expected_Yr1;
        input [3:0] expected_Yr2;
        input [3:0] expected_Yr3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Yi0 === (expected_Yi0 ^ Yi0 ^ expected_Yi0) &&
                expected_Yi1 === (expected_Yi1 ^ Yi1 ^ expected_Yi1) &&
                expected_Yi2 === (expected_Yi2 ^ Yi2 ^ expected_Yi2) &&
                expected_Yi3 === (expected_Yi3 ^ Yi3 ^ expected_Yi3) &&
                expected_Yr0 === (expected_Yr0 ^ Yr0 ^ expected_Yr0) &&
                expected_Yr1 === (expected_Yr1 ^ Yr1 ^ expected_Yr1) &&
                expected_Yr2 === (expected_Yr2 ^ Yr2 ^ expected_Yr2) &&
                expected_Yr3 === (expected_Yr3 ^ Yr3 ^ expected_Yr3)) begin
                $display("PASS");
                $display("  Outputs: Yi0=%h, Yi1=%h, Yi2=%h, Yi3=%h, Yr0=%h, Yr1=%h, Yr2=%h, Yr3=%h",
                         Yi0, Yi1, Yi2, Yi3, Yr0, Yr1, Yr2, Yr3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Yi0=%h, Yi1=%h, Yi2=%h, Yi3=%h, Yr0=%h, Yr1=%h, Yr2=%h, Yr3=%h",
                         expected_Yi0, expected_Yi1, expected_Yi2, expected_Yi3, expected_Yr0, expected_Yr1, expected_Yr2, expected_Yr3);
                $display("  Got:      Yi0=%h, Yi1=%h, Yi2=%h, Yi3=%h, Yr0=%h, Yr1=%h, Yr2=%h, Yr3=%h",
                         Yi0, Yi1, Yi2, Yi3, Yr0, Yr1, Yr2, Yr3);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
