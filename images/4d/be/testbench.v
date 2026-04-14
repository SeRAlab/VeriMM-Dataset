`timescale 1ns/1ps

module decoder_2to4_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] binary_in;
    reg enable;
    wire [3:0] one_hot_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_2to4 dut (
        .binary_in(binary_in),
        .enable(enable),
        .one_hot_out(one_hot_out)
    );
    task testcase001;

        begin
            test_num = 1;
            enable = 1'b0;
            binary_in = 2'b00;
            $display("Testcase %0d: Enable=0, Binary_in=2'b00", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            enable = 1'b0;
            binary_in = 2'b11;
            $display("Testcase %0d: Enable=0, Binary_in=2'b11", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            enable = 1'b1;
            binary_in = 2'b00;
            $display("Testcase %0d: Enable=1, Binary_in=2'b00", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            enable = 1'b1;
            binary_in = 2'b01;
            $display("Testcase %0d: Enable=1, Binary_in=2'b01", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            enable = 1'b1;
            binary_in = 2'b10;
            $display("Testcase %0d: Enable=1, Binary_in=2'b10", test_num);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            enable = 1'b1;
            binary_in = 2'b11;
            $display("Testcase %0d: Enable=1, Binary_in=2'b11", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            enable = 1'b1;
            binary_in = 2'b10;
            #5;
            enable = 1'b0;
            $display("Testcase %0d: Dynamic disable (Enable 1 -> 0)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_2to4 Testbench");
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
        input [3:0] expected_one_hot_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_one_hot_out === (expected_one_hot_out ^ one_hot_out ^ expected_one_hot_out)) begin
                $display("PASS");
                $display("  Outputs: one_hot_out=%h",
                         one_hot_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: one_hot_out=%h",
                         expected_one_hot_out);
                $display("  Got:      one_hot_out=%h",
                         one_hot_out);
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
