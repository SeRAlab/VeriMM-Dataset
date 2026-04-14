`timescale 1ns/1ps

module fm_avalon_tb;

    // Testbench signals (sequential circuit)
    reg clk_core;
    reg i_ack;
    reg [9:0] i_av_adr;
    reg [3:0] i_av_be;
    reg i_av_r;
    reg i_av_w;
    reg [31:0] i_av_wd;
    reg [31:0] i_rd;
    reg i_rstr;
    reg rst_x;
    wire [9:0] o_adrs;
    wire [31:0] o_av_rd;
    wire o_av_wait;
    wire [3:0] o_be;
    wire o_req;
    wire [31:0] o_wd;
    wire o_wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fm_avalon dut (
        .clk_core(clk_core),
        .i_ack(i_ack),
        .i_av_adr(i_av_adr),
        .i_av_be(i_av_be),
        .i_av_r(i_av_r),
        .i_av_w(i_av_w),
        .i_av_wd(i_av_wd),
        .i_rd(i_rd),
        .i_rstr(i_rstr),
        .rst_x(rst_x),
        .o_adrs(o_adrs),
        .o_av_rd(o_av_rd),
        .o_av_wait(o_av_wait),
        .o_be(o_be),
        .o_req(o_req),
        .o_wd(o_wd),
        .o_wr(o_wr)
    );

    // Clock generation (10ns period)
    initial begin
        clk_core = 0;
        forever #5 clk_core = ~clk_core;
    end

        task reset_dut;

        begin
            rst_x = 0;
            i_ack = 0;
            i_av_adr = 0;
            i_av_be = 0;
            i_av_r = 0;
            i_av_w = 0;
            i_av_wd = 0;
            i_rd = 0;
            i_rstr = 0;
            #20;
            rst_x = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Write Transaction", test_num);
            reset_dut();

            @(posedge clk_core);
            i_av_w   <= 1'b1;
            i_av_adr <= 10'h1A5;
            i_av_wd  <= 32'hDEADBEEF;
            i_av_be  <= 4'hF;


            @(posedge clk_core);
            i_av_w   <= 1'b0;


            i_ack    <= 1'b1;

            @(posedge clk_core);
            i_ack    <= 1'b0;




            #1;





            check_outputs(10'h1A5, 32'h0, 1'b0, 4'hF, 1'b0, 32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Basic Read Transaction", test_num);
            reset_dut();

            @(posedge clk_core);
            i_av_r   <= 1'b1;
            i_av_adr <= 10'h2B0;
            i_av_be  <= 4'hF;

            @(posedge clk_core);
            i_av_r   <= 1'b0;


            i_rd     <= 32'hCAFEBABE;
            i_ack    <= 1'b1;

            @(posedge clk_core);
            i_ack    <= 1'b0;


            #1;



            check_outputs(10'h2B0, 32'hCAFEBABE, 1'b0, 4'hF, 1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Write with Delayed Ack", test_num);
            reset_dut();

            @(posedge clk_core);
            i_av_w   <= 1'b1;
            i_av_adr <= 10'h077;
            i_av_wd  <= 32'h12345678;
            i_av_be  <= 4'hC;


            repeat(3) @(posedge clk_core);

            i_ack    <= 1'b1;
            @(posedge clk_core);
            i_ack    <= 1'b0;
            i_av_w   <= 1'b0;


            #1;



            check_outputs(10'h077, 32'h0, 1'b0, 4'hC, 1'b0, 32'h12345678, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Read with Restructuring Flag", test_num);
            reset_dut();

            @(posedge clk_core);
            i_av_r   <= 1'b1;
            i_rstr   <= 1'b1;
            i_av_adr <= 10'h001;
            i_av_be  <= 4'hF;

            @(posedge clk_core);
            i_rd     <= 32'h11223344;
            i_ack    <= 1'b1;

            @(posedge clk_core);
            i_ack    <= 1'b0;
            i_rstr   <= 1'b0;
            i_av_r   <= 1'b0;


            #1;



            check_outputs(10'h001, 32'h11223344, 1'b0, 4'hF, 1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Consecutive Write-Read", test_num);
            reset_dut();


            @(posedge clk_core);
            i_av_w   <= 1'b1;
            i_av_adr <= 10'h010;
            i_av_wd  <= 32'hAAAA5555;
            @(posedge clk_core);
            i_ack    <= 1'b1;
            @(posedge clk_core);
            i_ack    <= 1'b0;
            i_av_w   <= 1'b0;


            @(posedge clk_core);
            i_av_r   <= 1'b1;
            i_av_adr <= 10'h020;
            @(posedge clk_core);
            i_rd     <= 32'h5555AAAA;
            i_ack    <= 1'b1;
            @(posedge clk_core);
            i_ack    <= 1'b0;
            i_av_r   <= 1'b0;


            #1;



            check_outputs(10'h020, 32'h5555AAAA, 1'b0, 4'h0, 1'b0, 32'h0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fm_avalon Testbench");
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
        input [9:0] expected_o_adrs;
        input [31:0] expected_o_av_rd;
        input expected_o_av_wait;
        input [3:0] expected_o_be;
        input expected_o_req;
        input [31:0] expected_o_wd;
        input expected_o_wr;
        begin
            if (expected_o_adrs === (expected_o_adrs ^ o_adrs ^ expected_o_adrs) &&
                expected_o_av_rd === (expected_o_av_rd ^ o_av_rd ^ expected_o_av_rd) &&
                expected_o_av_wait === (expected_o_av_wait ^ o_av_wait ^ expected_o_av_wait) &&
                expected_o_be === (expected_o_be ^ o_be ^ expected_o_be) &&
                expected_o_req === (expected_o_req ^ o_req ^ expected_o_req) &&
                expected_o_wd === (expected_o_wd ^ o_wd ^ expected_o_wd) &&
                expected_o_wr === (expected_o_wr ^ o_wr ^ expected_o_wr)) begin
                $display("PASS");
                $display("  Outputs: o_adrs=%h, o_av_rd=%h, o_av_wait=%b, o_be=%h, o_req=%b, o_wd=%h, o_wr=%b",
                         o_adrs, o_av_rd, o_av_wait, o_be, o_req, o_wd, o_wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_adrs=%h, o_av_rd=%h, o_av_wait=%b, o_be=%h, o_req=%b, o_wd=%h, o_wr=%b",
                         expected_o_adrs, expected_o_av_rd, expected_o_av_wait, expected_o_be, expected_o_req, expected_o_wd, expected_o_wr);
                $display("  Got:      o_adrs=%h, o_av_rd=%h, o_av_wait=%b, o_be=%h, o_req=%b, o_wd=%h, o_wr=%b",
                         o_adrs, o_av_rd, o_av_wait, o_be, o_req, o_wd, o_wr);
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
        $dumpvars(0,clk_core, i_ack, i_av_adr, i_av_be, i_av_r, i_av_w, i_av_wd, i_rd, i_rstr, rst_x, o_adrs, o_av_rd, o_av_wait, o_be, o_req, o_wd, o_wr);
    end

endmodule
