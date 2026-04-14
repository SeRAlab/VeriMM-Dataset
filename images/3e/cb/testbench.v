`timescale 1ns/1ps

module rle_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [31:0] compressed_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_compressor dut (
        .data_in(data_in),
        .compressed_out(compressed_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Example Case (11110000)", test_num);
            data_in = 8'b11110000;
            #1;

            check_outputs(32'h14040000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inverse Example (00001111)", test_num);
            data_in = 8'b00001111;
            #1;

            check_outputs(32'h04140000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones (11111111)", test_num);
            data_in = 8'b11111111;
            #1;

            check_outputs(32'h18000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros (00000000)", test_num);
            data_in = 8'b00000000;
            #1;

            check_outputs(32'h08000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits Starting with 1", test_num);
            data_in = 8'b10101010;


            #1;



            check_outputs(32'h11011101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits Starting with 0", test_num);
            data_in = 8'b01010101;

            #1;


            check_outputs(32'h01110111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Four Equal Runs", test_num);
            data_in = 8'b11001100;
            #1;

            check_outputs(32'h12021202);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Three Runs (Mixed Lengths)", test_num);
            data_in = 8'b11100111;
            #1;

            check_outputs(32'h13021300);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Leading Single Bit Run", test_num);
            data_in = 8'b01111111;
            #1;

            check_outputs(32'h01170000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Trailing Single Bit Run", test_num);
            data_in = 8'b00000001;
            #1;

            check_outputs(32'h07110000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_compressor Testbench");
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
        input [31:0] expected_compressed_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_compressed_out === (expected_compressed_out ^ compressed_out ^ expected_compressed_out)) begin
                $display("PASS");
                $display("  Outputs: compressed_out=%h",
                         compressed_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_out=%h",
                         expected_compressed_out);
                $display("  Got:      compressed_out=%h",
                         compressed_out);
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
