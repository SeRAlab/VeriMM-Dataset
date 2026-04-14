`timescale 1ns/1ps

module DAC_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] din;
    reg valid;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC dut (
        .din(din),
        .valid(valid),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid=0, din=0x0000 (Boundary Low)", test_num);
            valid = 1'b0;
            din = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid=0, din=0xFFFF (Boundary High, Valid Low)", test_num);
            valid = 1'b0;
            din = 16'hFFFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid=0, din=0x1234 (Random value, Valid Low)", test_num);
            valid = 1'b0;
            din = 16'h1234;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid=1, din=0x0000 (Valid High, Min Input)", test_num);
            valid = 1'b1;
            din = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid=1, din=0xFFFF (Valid High, Max Input)", test_num);
            valid = 1'b1;
            din = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid=1, din=0x5555 (Valid High, Mid Input 1)", test_num);
            valid = 1'b1;
            din = 16'h5555;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid=1, din=0xAAAA (Valid High, Mid Input 2)", test_num);
            valid = 1'b1;
            din = 16'hAAAA;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle Valid High -> Low", test_num);
            din = 16'hC0DE;
            valid = 1'b1;
            #5;
            valid = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle Valid Low -> High", test_num);
            din = 16'hBEEF;
            valid = 1'b0;
            #5;
            valid = 1'b1;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [15:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
