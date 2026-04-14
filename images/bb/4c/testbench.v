`timescale 1ns/1ps

module priority_encoder_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [2:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_8bit dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 0 only", test_num);
            data_in = 8'b0000_0001;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 1 only", test_num);
            data_in = 8'b0000_0010;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 2 only", test_num);
            data_in = 8'b0000_0100;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 3 only", test_num);
            data_in = 8'b0000_1000;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 4 only", test_num);
            data_in = 8'b0001_0000;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 5 only", test_num);
            data_in = 8'b0010_0000;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 6 only", test_num);
            data_in = 8'b0100_0000;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bit 7 only", test_num);
            data_in = 8'b1000_0000;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority check - All bits set", test_num);
            data_in = 8'b1111_1111;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority check - Multiple low bits", test_num);
            data_in = 8'b0000_0111;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority check - Sparse bits (Bit 5 high)", test_num);
            data_in = 8'b0010_1010;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority check - Bits 7 and 0", test_num);
            data_in = 8'b1000_0001;
            #1;

            check_outputs(3'd7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_8bit Testbench");
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
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [2:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
