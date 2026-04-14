`timescale 1ns/1ps

module convolutional_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire encoded_out1;
    wire encoded_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    convolutional_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .encoded_out1(encoded_out1),
        .encoded_out2(encoded_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            @(posedge clk);
            #2 reset = 0;

            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: Input sequence {1}", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 0;
            @(posedge clk);
            #2;
            $display("Test %0d: Input sequence {0}", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            #2;
            $display("Test %0d: Input sequence {1, 1}", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            #2;
            $display("Test %0d: Input sequence {1, 0, 1}", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            #2;
            $display("Test %0d: Input sequence {1, 1, 1}", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            #2;
            $display("Test %0d: Input sequence {0, 1, 1}", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            #2;
            $display("Test %0d: Input sequence {1, 0, 0}", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            #2;
            $display("Test %0d: Input sequence {1, 1, 0, 0}", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            #2;
            $display("Test %0d: Input sequence {1, 0, 1, 0}", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            #2;
            $display("Test %0d: Input sequence {0, 0, 0}", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("convolutional_encoder Testbench");
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
        input expected_encoded_out1;
        input expected_encoded_out2;
        begin
            if (expected_encoded_out1 === (expected_encoded_out1 ^ encoded_out1 ^ expected_encoded_out1) &&
                expected_encoded_out2 === (expected_encoded_out2 ^ encoded_out2 ^ expected_encoded_out2)) begin
                $display("PASS");
                $display("  Outputs: encoded_out1=%b, encoded_out2=%b",
                         encoded_out1, encoded_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out1=%b, encoded_out2=%b",
                         expected_encoded_out1, expected_encoded_out2);
                $display("  Got:      encoded_out1=%b, encoded_out2=%b",
                         encoded_out1, encoded_out2);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, data_in, reset, encoded_out1, encoded_out2);
    end

endmodule
