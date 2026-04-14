`timescale 1ns/1ps

module chacha20_core_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] block_index;
    reg [31:0] key;
    reg [31:0] nonce;
    wire [31:0] output_stream;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_core dut (
        .block_index(block_index),
        .key(key),
        .nonce(nonce),
        .output_stream(output_stream)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);

            key = 32'h0;
            nonce = 32'h0;
            block_index = 32'h0;


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Sum and Rotation", test_num);
            key = 32'h00000001;
            nonce = 32'h00000002;
            block_index = 32'h00000003;


            #1;



            check_outputs(32'h00000300);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Key Overflow (Addition Wrap)", test_num);
            key = 32'hFFFFFFFF;
            nonce = 32'h00000001;
            block_index = 32'h00000000;


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rotation Carry-around", test_num);
            key = 32'h40000000;
            nonce = 32'h0;
            block_index = 32'h0;


            #1;



            check_outputs(32'h00000020);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Inputs", test_num);
            key = 32'hFFFFFFFF;
            nonce = 32'hFFFFFFFF;
            block_index = 32'hFFFFFFFF;



            #1;




            check_outputs(32'hFFFFFEFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Nonce/Index Interaction", test_num);
            key = 32'h12345678;
            nonce = 32'h0000ABCD;
            block_index = 32'h00000001;



            #1;




            check_outputs(32'h9A812309);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checkerboard Pattern", test_num);
            key = 32'hAAAAAAAA;
            nonce = 32'h55555555;
            block_index = 32'h00000001;



            #1;




            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_core Testbench");
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
        input [31:0] expected_output_stream;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_stream === (expected_output_stream ^ output_stream ^ expected_output_stream)) begin
                $display("PASS");
                $display("  Outputs: output_stream=%h",
                         output_stream);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_stream=%h",
                         expected_output_stream);
                $display("  Got:      output_stream=%h",
                         output_stream);
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
