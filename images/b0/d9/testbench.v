`timescale 1ns/1ps

module avg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    reg valid_in;
    wire [7:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    avg dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
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
            rst_n = 0;
            data_in = 0;
            valid_in = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic average (10, 20, 30, 40)");
            reset_dut();
            @(posedge clk);
            #1 data_in = 8'd10; valid_in = 1'b1;
            @(posedge clk);
            #1 data_in = 8'd20; valid_in = 1'b1;
            @(posedge clk);
            #1 data_in = 8'd30; valid_in = 1'b1;
            @(posedge clk);
            #1 data_in = 8'd40; valid_in = 1'b1;
            @(posedge clk);
            #1 valid_in = 1'b0;


            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(8'd25, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Maximum values (255, 255, 255, 255)");
            reset_dut();
            @(posedge clk);
            #1 data_in = 8'hFF; valid_in = 1'b1;
            repeat(3) begin
                @(posedge clk);
                #1 data_in = 8'hFF;
            end
            @(posedge clk);
            #1 valid_in = 1'b0;

            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Intermittent valid_in");
            reset_dut();
            @(posedge clk);
            #1 data_in = 8'd4; valid_in = 1'b1;  @(posedge clk);
            #1 valid_in = 1'b0;                  @(posedge clk);
            #1 data_in = 8'd8; valid_in = 1'b1;  @(posedge clk);
            #1 valid_in = 1'b0;                  repeat(2) @(posedge clk);
            #1 data_in = 8'd12; valid_in = 1'b1; @(posedge clk);
            #1 data_in = 8'd16; valid_in = 1'b1; @(posedge clk);
            #1 valid_in = 1'b0;

            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(8'd10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Truncation check (Sum=7)");
            reset_dut();
            @(posedge clk);
            #1 data_in = 8'd1; valid_in = 1'b1;
            @(posedge clk);
            #1 data_in = 8'd2; valid_in = 1'b1;
            @(posedge clk);
            #1 data_in = 8'd1; valid_in = 1'b1;
            @(posedge clk);
            #1 data_in = 8'd3; valid_in = 1'b1;
            @(posedge clk);
            #1 valid_in = 1'b0;

            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(8'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Consecutive sets check");
            reset_dut();

            @(posedge clk);
            #1 data_in = 8'd10; valid_in = 1'b1;
            repeat(3) @(posedge clk) #1 data_in = 8'd10;
            @(posedge clk);
            #1 valid_in = 1'b0;
            while (!valid_out) @(posedge clk);


            @(posedge clk);
            #1 data_in = 8'd20; valid_in = 1'b1;
            repeat(3) @(posedge clk) #1 data_in = 8'd20;
            @(posedge clk);
            #1 valid_in = 1'b0;

            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(8'd20, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("avg Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rst_n, valid_in, data_out, valid_out);
    end

endmodule
