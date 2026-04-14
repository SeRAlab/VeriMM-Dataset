`timescale 1ns/1ps

module fifo_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_enable;
    reg reset;
    reg [7:0] write_data;
    reg write_enable;
    wire empty;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo dut (
        .clk(clk),
        .read_enable(read_enable),
        .reset(reset),
        .write_data(write_data),
        .write_enable(write_enable),
        .empty(empty),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            write_enable = 0;
            read_enable = 0;
            write_data = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial state check...");
            reset_dut();

            #1;


            check_outputs(1'b1, read_data);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Write/Read...");
            reset_dut();

            @(negedge clk);
            write_enable = 1;
            write_data = 8'hAA;
            @(negedge clk);
            write_enable = 0;

            @(negedge clk);
            read_enable = 1;
            @(negedge clk);
            read_enable = 0;

            #1;


            check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequential Write/Read...");
            reset_dut();

            @(negedge clk);
            write_enable = 1; write_data = 8'h11;
            @(negedge clk);
            write_data = 8'h22;
            @(negedge clk);
            write_data = 8'h33;
            @(negedge clk);
            write_enable = 0;


            @(negedge clk);
            read_enable = 1;
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);
            read_enable = 0;


            #1;



            check_outputs(1'b1, 8'h33);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Full depth Write/Read...");
            reset_dut();

            write_enable = 1;
            for (i = 0; i < 16; i = i + 1) begin
                write_data = i[7:0];
                @(negedge clk);
            end
            write_enable = 0;


            read_enable = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(negedge clk);
            end
            read_enable = 0;


            #1;



            check_outputs(1'b1, 8'h0F);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Partial Read Empty check...");
            reset_dut();

            @(negedge clk);
            write_enable = 1; write_data = 8'hA1;
            @(negedge clk);
            write_data = 8'hB2;
            @(negedge clk);
            write_enable = 0;


            @(negedge clk);
            read_enable = 1;
            @(negedge clk);
            read_enable = 0;


            #1;



            check_outputs(1'b0, 8'hA1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Simultaneous Write/Read...");
            reset_dut();

            @(negedge clk);
            write_enable = 1; write_data = 8'hDE;
            @(negedge clk);


            read_enable = 1;
            write_data = 8'hAD;
            @(negedge clk);
            read_enable = 0;
            write_enable = 0;


            #1;



            check_outputs(1'b0, 8'hDE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo Testbench");
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
        input expected_empty;
        input [7:0] expected_read_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, read_data=%h",
                         empty, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, read_data=%h",
                         expected_empty, expected_read_data);
                $display("  Got:      empty=%b, read_data=%h",
                         empty, read_data);
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
        $dumpvars(0,clk, read_enable, reset, write_data, write_enable, empty, read_data);
    end

endmodule
