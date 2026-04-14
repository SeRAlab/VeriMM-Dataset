`timescale 1ns/1ps

module deserializer_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] data_in;
    reg reset;
    reg valid_in;
    wire [15:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid_in(valid_in),
        .data_out(data_out),
        .valid_out(valid_out)
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
            valid_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (FFFF)", test_num);
            reset_dut();
            repeat(8) begin
                valid_in = 1;
                data_in = 2'b11;
                @(posedge clk);
                #1;
            end
            valid_in = 0;
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (0000)", test_num);
            reset_dut();
            repeat(8) begin
                valid_in = 1;
                data_in = 2'b00;
                @(posedge clk);
                #1;
            end
            valid_in = 0;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 01 (5555)", test_num);
            reset_dut();
            repeat(8) begin
                valid_in = 1;
                data_in = 2'b01;
                @(posedge clk);
                #1;
            end
            valid_in = 0;
            #1;

            check_outputs(16'h5555, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 10 (AAAA)", test_num);
            reset_dut();
            repeat(8) begin
                valid_in = 1;
                data_in = 2'b10;
                @(posedge clk);
                #1;
            end
            valid_in = 0;
            #1;

            check_outputs(16'hAAAA, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 1234", test_num);
            reset_dut();

            valid_in = 1;
            data_in = 2'b00; @(posedge clk); #1;
            data_in = 2'b01; @(posedge clk); #1;
            data_in = 2'b00; @(posedge clk); #1;
            data_in = 2'b10; @(posedge clk); #1;
            data_in = 2'b00; @(posedge clk); #1;
            data_in = 2'b11; @(posedge clk); #1;
            data_in = 2'b01; @(posedge clk); #1;
            data_in = 2'b00; @(posedge clk); #1;

            valid_in = 0;
            #1;

            check_outputs(16'h1234, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Transmission (Valid should be low)", test_num);
            reset_dut();
            repeat(4) begin
                valid_in = 1;
                data_in = 2'b11;
                @(posedge clk);
                #1;
            end
            valid_in = 0;

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid_in Low Gating", test_num);
            reset_dut();


            repeat(4) begin
                valid_in = 1;
                data_in = 2'b11;
                @(posedge clk);
                #1;
            end


            valid_in = 0;
            data_in = 2'b11;
            repeat(4) @(posedge clk);
            #1;


            repeat(4) begin
                valid_in = 1;
                data_in = 2'b00;
                @(posedge clk);
                #1;
            end

            valid_in = 0;

            #1;


            check_outputs(16'hFF00, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer_16bit Testbench");
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
        input [15:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data_in, reset, valid_in, data_out, valid_out);
    end

endmodule
