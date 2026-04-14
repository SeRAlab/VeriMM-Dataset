`timescale 1ns/1ps

module deserializer_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] data_in;
    reg rst;
    wire [15:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All Zeros", test_num);
            reset_dut();
            repeat(7) begin
                data_in = 2'b00;
                @(posedge clk);
            end
            data_in = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All Ones", test_num);
            reset_dut();
            repeat(8) begin
                data_in = 2'b11;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating pattern 10...", test_num);
            reset_dut();
            repeat(8) begin
                data_in = 2'b10;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'hAAAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating pattern 01...", test_num);
            reset_dut();
            repeat(8) begin
                data_in = 2'b01;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'h5555, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Mixed Pattern C9C9", test_num);
            reset_dut();

            data_in = 2'b11; @(posedge clk);
            data_in = 2'b00; @(posedge clk);
            data_in = 2'b10; @(posedge clk);
            data_in = 2'b01; @(posedge clk);
            data_in = 2'b11; @(posedge clk);
            data_in = 2'b00; @(posedge clk);
            data_in = 2'b10; @(posedge clk);
            data_in = 2'b01; @(posedge clk);
            #1;
            #1;

            check_outputs(16'hC9C9, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Pattern 1B1B", test_num);
            reset_dut();

            data_in = 2'b00; @(posedge clk);
            data_in = 2'b01; @(posedge clk);
            data_in = 2'b10; @(posedge clk);
            data_in = 2'b11; @(posedge clk);
            data_in = 2'b00; @(posedge clk);
            data_in = 2'b01; @(posedge clk);
            data_in = 2'b10; @(posedge clk);
            data_in = 2'b11; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1B1B, 1'b1);
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
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, data_in, rst, data_out, valid);
    end

endmodule
