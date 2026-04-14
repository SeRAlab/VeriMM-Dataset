`timescale 1ns/1ps

module pcie_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] signal;
    wire [1:0] control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_decoder dut (
        .signal(signal),
        .control(control)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: No Operation (00000)", test_num);
            signal = 5'b00000;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Read Operation (00001)", test_num);
            signal = 5'b00001;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Write Operation (00010)", test_num);
            signal = 5'b00010;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Reserved Operation (00011)", test_num);
            signal = 5'b00011;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Reserved Operation (01010)", test_num);
            signal = 5'b01010;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Reserved Operation (10000)", test_num);
            signal = 5'b10000;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Reserved Operation (11111)", test_num);
            signal = 5'b11111;
            #1;

            check_outputs(2'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_decoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [1:0] expected_control;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control === (expected_control ^ control ^ expected_control)) begin
                $display("PASS");
                $display("  Outputs: control=%h",
                         control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control=%h",
                         expected_control);
                $display("  Got:      control=%h",
                         control);
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
