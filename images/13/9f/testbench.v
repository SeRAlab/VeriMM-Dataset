`timescale 1ns/1ps

module turbo_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    wire [5:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .encoded_out(encoded_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            data_in = 4'b0000;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All Ones", test_num);
            reset_dut();
            data_in = 4'b1111;

            #1;


            check_outputs(6'b111111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Pattern 1010", test_num);
            reset_dut();
            data_in = 4'b1010;

            #1;


            check_outputs(6'b011010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Pattern 0101", test_num);
            reset_dut();
            data_in = 4'b0101;

            #1;


            check_outputs(6'b100101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Single Bit LSB", test_num);
            reset_dut();
            data_in = 4'b0001;
            #1;

            check_outputs(6'b010001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Single Bit MSB", test_num);
            reset_dut();
            data_in = 4'b1000;
            #1;

            check_outputs(6'b101000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Middle Bits 0110", test_num);
            reset_dut();
            data_in = 4'b0110;
            #1;

            check_outputs(6'b110110);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Reset behavior", test_num);
            reset_dut();
            data_in = 4'b1111;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            if (encoded_out === 6'b000000) begin
                $display("PASS: Reset cleared output");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Reset did not clear output");
                fail_count = fail_count + 1;
            end
            reset = 0;
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
        input [5:0] expected_encoded_out;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h",
                         encoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h",
                         expected_encoded_out);
                $display("  Got:      encoded_out=%h",
                         encoded_out);
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
        $dumpvars(0,clk, data_in, reset, encoded_out);
    end

endmodule
