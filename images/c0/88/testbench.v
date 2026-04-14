`timescale 1ns/1ps

module mfifo_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] i_dt;
    reg i_renable;
    reg i_wstrobe;
    reg rst_x;
    wire [2:0] o_dnum;
    wire [31:0] o_dt;
    wire o_empty;
    wire o_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mfifo dut (
        .clk(clk),
        .i_dt(i_dt),
        .i_renable(i_renable),
        .i_wstrobe(i_wstrobe),
        .rst_x(rst_x),
        .o_dnum(o_dnum),
        .o_dt(o_dt),
        .o_empty(o_empty),
        .o_full(o_full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_x = 0;
        i_wstrobe = 0;
        i_renable = 0;
        i_dt = 0;
        @(posedge clk);
        #1 rst_x = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(3'd0, 32'h0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();


        i_wstrobe = 1;
        i_dt = 32'hDEADBEEF;
        @(posedge clk);
        #1 i_wstrobe = 0;


        #1;



        check_outputs(3'd1, 32'hDEADBEEF, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();


        @(posedge clk);
        i_wstrobe = 1; i_dt = 32'h1; @(posedge clk);
        i_wstrobe = 1; i_dt = 32'h2; @(posedge clk);
        i_wstrobe = 1; i_dt = 32'h3; @(posedge clk);
        i_wstrobe = 1; i_dt = 32'h4; @(posedge clk);
        #1 i_wstrobe = 0;


        #1;



        check_outputs(3'd4, 32'h1, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();


        i_wstrobe = 1; i_dt = 32'hA; @(posedge clk);
        i_wstrobe = 1; i_dt = 32'hB; @(posedge clk);
        i_wstrobe = 1; i_dt = 32'hC; @(posedge clk);
        #1 i_wstrobe = 0;


        i_renable = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1 i_renable = 0;


        #1;



        check_outputs(3'd0, 32'hC, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();


        i_wstrobe = 1;
        i_dt = 32'h1; @(posedge clk);
        i_dt = 32'h2; @(posedge clk);
        i_dt = 32'h3; @(posedge clk);
        i_dt = 32'h4; @(posedge clk);
        i_dt = 32'h5; @(posedge clk);
        #1 i_wstrobe = 0;


        #1;



        check_outputs(3'd4, 32'h1, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();


        i_renable = 1;
        repeat(2) @(posedge clk);
        #1 i_renable = 0;


        #1;



        check_outputs(3'd0, 32'h0, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();


        i_wstrobe = 1; i_dt = 32'h10; @(posedge clk);
        i_wstrobe = 1; i_dt = 32'h20; @(posedge clk);
        #1 i_wstrobe = 0;


        i_renable = 1;
        i_wstrobe = 1;
        i_dt = 32'h30;
        @(posedge clk);
        #1 i_renable = 0; i_wstrobe = 0;


        #1;



        check_outputs(3'd2, 32'h20, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();


        i_wstrobe = 1;
        i_dt = 32'h1; @(posedge clk);
        i_dt = 32'h2; @(posedge clk);
        i_dt = 32'h3; @(posedge clk);
        i_wstrobe = 0; i_renable = 1;
        @(posedge clk);
        @(posedge clk);
        i_renable = 0; i_wstrobe = 1;
        i_dt = 32'h4; @(posedge clk);
        i_dt = 32'h5; @(posedge clk);
        i_dt = 32'h6; @(posedge clk);
        #1 i_wstrobe = 0;


        #1;



        check_outputs(3'd4, 32'h3, 1'b0, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mfifo Testbench");
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
        input [2:0] expected_o_dnum;
        input [31:0] expected_o_dt;
        input expected_o_empty;
        input expected_o_full;
        begin
            if (expected_o_dnum === (expected_o_dnum ^ o_dnum ^ expected_o_dnum) &&
                expected_o_dt === (expected_o_dt ^ o_dt ^ expected_o_dt) &&
                expected_o_empty === (expected_o_empty ^ o_empty ^ expected_o_empty) &&
                expected_o_full === (expected_o_full ^ o_full ^ expected_o_full)) begin
                $display("PASS");
                $display("  Outputs: o_dnum=%h, o_dt=%h, o_empty=%b, o_full=%b",
                         o_dnum, o_dt, o_empty, o_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_dnum=%h, o_dt=%h, o_empty=%b, o_full=%b",
                         expected_o_dnum, expected_o_dt, expected_o_empty, expected_o_full);
                $display("  Got:      o_dnum=%h, o_dt=%h, o_empty=%b, o_full=%b",
                         o_dnum, o_dt, o_empty, o_full);
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
        $dumpvars(0,clk, i_dt, i_renable, i_wstrobe, rst_x, o_dnum, o_dt, o_empty, o_full);
    end

endmodule
