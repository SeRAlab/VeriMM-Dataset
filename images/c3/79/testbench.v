`timescale 1ns/1ps

module light_control_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] als;
    reg [11:0] dll;
    reg en;
    wire [7:0] dim;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    light_control dut (
        .als(als),
        .dll(dll),
        .en(en),
        .dim(dim)
    );
    task testcase001;

        begin
            $display("Testcase 001: Module disabled (en=0)");
            en = 0;
            als = 12'd4000;
            dll = 12'd1000;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: ALS equals DLL (en=1)");
            en = 1;
            als = 12'd2000;
            dll = 12'd2000;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: ALS less than DLL (en=1)");
            en = 1;
            als = 12'd500;
            dll = 12'd1500;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Normal calculation (Exact)");
            en = 1;
            als = 12'd2000;
            dll = 12'd1040;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Normal calculation (Truncated division)");
            en = 1;
            als = 12'd1000;
            dll = 12'd500;
            #1;

            check_outputs(8'd31);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Maximum range calculation");
            en = 1;
            als = 12'd4095;
            dll = 12'd0;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Difference less than 16");
            en = 1;
            als = 12'd100;
            dll = 12'd90;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Toggle enable signal");
            en = 1;
            als = 12'd2000;
            dll = 12'd0;
            #1;
            en = 0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("light_control Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_dim;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dim === (expected_dim ^ dim ^ expected_dim)) begin
                $display("PASS");
                $display("  Outputs: dim=%h",
                         dim);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dim=%h",
                         expected_dim);
                $display("  Got:      dim=%h",
                         dim);
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
