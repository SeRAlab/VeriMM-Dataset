`timescale 1ns/1ps

module audio_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] audio_in;
    wire [7:0] compressed_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_compressor dut (
        .audio_in(audio_in),
        .compressed_out(compressed_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            audio_in = 5'b11111;
            $display("Test %0d: All ones (Capped Run)", test_num);
            #1;

            check_outputs(8'hF4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            audio_in = 5'b00000;
            $display("Test %0d: All zeros (Capped Run)", test_num);
            #1;

            check_outputs(8'hD0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            audio_in = 5'b11100;
            $display("Test %0d: 3-2 Split (1s then 0s)", test_num);
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            audio_in = 5'b00111;
            $display("Test %0d: 2-3 Split (0s then 1s)", test_num);
            #1;

            check_outputs(8'h9C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            audio_in = 5'b10101;
            $display("Test %0d: Alternating 10101", test_num);
            #1;

            check_outputs(8'h69);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            audio_in = 5'b01010;
            $display("Test %0d: Alternating 01010", test_num);
            #1;

            check_outputs(8'h2D);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            audio_in = 5'b11110;
            $display("Test %0d: 4 ones, 1 zero", test_num);
            #1;

            check_outputs(8'hED);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            audio_in = 5'b00001;
            $display("Test %0d: 4 zeros, 1 one", test_num);
            #1;

            check_outputs(8'hC9);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            audio_in = 5'b11011;
            $display("Test %0d: Mixed 2-1-2 run", test_num);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            audio_in = 5'b00110;
            $display("Test %0d: Mixed 2-2-1 run", test_num);
            #1;

            check_outputs(8'h95);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_compressor Testbench");
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
        input [7:0] expected_compressed_out;
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
