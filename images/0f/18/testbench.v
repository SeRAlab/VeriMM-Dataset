`timescale 1ns/1ps

module turbo_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_bits;
    reg rst;
    wire [15:0] encoded_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder dut (
        .clk(clk),
        .input_bits(input_bits),
        .rst(rst),
        .encoded_bits(encoded_bits)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_bits = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (8'h00)", test_num);
            reset_dut();
            input_bits = 8'h00;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (8'hFF)", test_num);
            reset_dut();
            input_bits = 8'hFF;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(encoded_bits);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (8'hAA)", test_num);
            reset_dut();
            input_bits = 8'hAA;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(encoded_bits);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (8'h55)", test_num);
            reset_dut();
            input_bits = 8'h55;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(encoded_bits);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB Only (8'h80)", test_num);
            reset_dut();
            input_bits = 8'h80;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(encoded_bits);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LSB Only (8'h01)", test_num);
            reset_dut();
            input_bits = 8'h01;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(encoded_bits);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Middle Nibble (8'h3C)", test_num);
            reset_dut();
            input_bits = 8'h3C;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(encoded_bits);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern (8'h96)", test_num);
            reset_dut();
            input_bits = 8'h96;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(encoded_bits);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_encoder Testbench");
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
        input [15:0] expected_encoded_bits;
        begin
            if (expected_encoded_bits === (expected_encoded_bits ^ encoded_bits ^ expected_encoded_bits)) begin
                $display("PASS");
                $display("  Outputs: encoded_bits=%h",
                         encoded_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_bits=%h",
                         expected_encoded_bits);
                $display("  Got:      encoded_bits=%h",
                         encoded_bits);
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
        $dumpvars(0,clk, input_bits, rst, encoded_bits);
    end

endmodule
