`timescale 1ns/1ps

module wbufifo_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg [65:0] i_data;
    reg i_rd;
    reg i_rst;
    reg i_wr;
    wire [65:0] o_data;
    wire o_empty_n;
    wire o_err;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wbufifo dut (
        .i_clk(i_clk),
        .i_data(i_data),
        .i_rd(i_rd),
        .i_rst(i_rst),
        .i_wr(i_wr),
        .o_data(o_data),
        .o_empty_n(o_empty_n),
        .o_err(o_err)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

    begin
        i_rst = 1;
        i_wr = 0;
        i_rd = 0;
        i_data = 66'h0;
        @(posedge i_clk);
        #1;
        i_rst = 0;
        @(posedge i_clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Initial Reset State");
        reset_dut();

        #1;


        check_outputs(66'bx, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Single Write and Read Operation");
        reset_dut();


        i_wr = 1;
        i_data = 66'h123456789ABCDEF0;
        @(posedge i_clk);
        #1;
        i_wr = 0;


        @(posedge i_clk);
        #1;


        i_rd = 1;
        @(posedge i_clk);
        #1;
        i_rd = 0;


        #1;



        check_outputs(66'h123456789ABCDEF0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: FIFO Sequential Order Check");
        reset_dut();


        i_wr = 1;
        i_data = 66'hA; @(posedge i_clk); #1;
        i_data = 66'hB; @(posedge i_clk); #1;
        i_data = 66'hC; @(posedge i_clk); #1;
        i_wr = 0;


        i_rd = 1; @(posedge i_clk); #1;
        i_rd = 0; @(posedge i_clk); #1;


        i_rd = 1; @(posedge i_clk); #1;
        i_rd = 0; @(posedge i_clk); #1;


        i_rd = 1; @(posedge i_clk); #1;
        i_rd = 0; @(posedge i_clk); #1;


        #1;



        check_outputs(66'hC, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Underflow Error Detection");
        reset_dut();


        i_rd = 1;
        @(posedge i_clk);
        #1;
        i_rd = 0;


        #1;



        check_outputs(66'bx, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Concurrent Write and Read");
        reset_dut();


        i_wr = 1;
        i_data = 66'hAAAA;
        @(posedge i_clk); #1;


        i_data = 66'hBBBB;
        i_rd = 1;
        @(posedge i_clk); #1;
        i_wr = 0;
        i_rd = 0;
        @(posedge i_clk); #1;


        #1;



        check_outputs(66'hAAAA, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    integer i;
    begin
        $display("Testcase 006: Overflow Error Detection");
        reset_dut();

        i_wr = 1;
        for (i = 0; i < 20; i = i + 1) begin
            i_data = i;
            @(posedge i_clk);
            #1;
        end
        i_wr = 0;


        #1;



        check_outputs(65'bx, 1'b1, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wbufifo Testbench");
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
        input [65:0] expected_o_data;
        input expected_o_empty_n;
        input expected_o_err;
        begin
            if (expected_o_data === (expected_o_data ^ o_data ^ expected_o_data) &&
                expected_o_empty_n === (expected_o_empty_n ^ o_empty_n ^ expected_o_empty_n) &&
                expected_o_err === (expected_o_err ^ o_err ^ expected_o_err)) begin
                $display("PASS");
                $display("  Outputs: o_data=%h, o_empty_n=%b, o_err=%b",
                         o_data, o_empty_n, o_err);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data=%h, o_empty_n=%b, o_err=%b",
                         expected_o_data, expected_o_empty_n, expected_o_err);
                $display("  Got:      o_data=%h, o_empty_n=%b, o_err=%b",
                         o_data, o_empty_n, o_err);
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
        $dumpvars(0,i_clk, i_data, i_rd, i_rst, i_wr, o_data, o_empty_n, o_err);
    end

endmodule
