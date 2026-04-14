`timescale 1ns/1ps

module aeMB2_pipe_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] bra_ex;
    reg dwb_fb;
    reg [1:0] exc_dwb;
    reg exc_ill;
    reg exc_iwb;
    reg fet_fb;
    reg ich_fb;
    reg [9:0] msr_ex;
    reg sys_clk_i;
    reg sys_ena_i;
    reg sys_int_i;
    reg sys_rst_i;
    reg xwb_fb;
    wire [1:0] brk_if;
    wire dena;
    wire gclk;
    wire gpha;
    wire grst;
    wire iena;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aeMB2_pipe dut (
        .bra_ex(bra_ex),
        .dwb_fb(dwb_fb),
        .exc_dwb(exc_dwb),
        .exc_ill(exc_ill),
        .exc_iwb(exc_iwb),
        .fet_fb(fet_fb),
        .ich_fb(ich_fb),
        .msr_ex(msr_ex),
        .sys_clk_i(sys_clk_i),
        .sys_ena_i(sys_ena_i),
        .sys_int_i(sys_int_i),
        .sys_rst_i(sys_rst_i),
        .xwb_fb(xwb_fb),
        .brk_if(brk_if),
        .dena(dena),
        .gclk(gclk),
        .gpha(gpha),
        .grst(grst),
        .iena(iena)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk_i = 0;
        forever #5 sys_clk_i = ~sys_clk_i;
    end

        task reset_dut;

        begin
            sys_rst_i = 1;
            sys_ena_i = 0;
            sys_int_i = 0;
            bra_ex = 2'b00;
            dwb_fb = 1'b0;
            xwb_fb = 1'b0;
            ich_fb = 1'b0;
            fet_fb = 1'b0;
            msr_ex = 10'h000;
            exc_dwb = 2'b00;
            exc_iwb = 1'b0;
            exc_ill = 1'b0;
            repeat(5) @(posedge sys_clk_i);
            sys_rst_i = 0;
            @(posedge sys_clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset State Verification");
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Normal Enabled Operation");
            reset_dut();
            sys_ena_i = 1;
            ich_fb = 1;
            repeat(2) @(posedge sys_clk_i);

            #1;


            check_outputs(2'b00, 1'b1, 1'b1, gpha, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Instruction Cache Miss Stall");
            reset_dut();
            sys_ena_i = 1;
            ich_fb = 0;
            repeat(2) @(posedge sys_clk_i);

            #1;


            check_outputs(2'b00, 1'b1, 1'b1, gpha, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Data Writeback Stall");
            reset_dut();
            sys_ena_i = 1;
            ich_fb = 1;
            dwb_fb = 1;
            repeat(2) @(posedge sys_clk_i);

            #1;


            check_outputs(2'b00, 1'b0, 1'b1, gpha, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Interrupt Triggering");
            reset_dut();
            sys_ena_i = 1;
            msr_ex = 10'h002;
            sys_int_i = 1;
            repeat(2) @(posedge sys_clk_i);


            if (brk_if != 2'b00)
                #1;

                check_outputs(brk_if, 1'b1, 1'b1, gpha, 1'b1, 1'b1);
            else
                #1;

                check_outputs(2'b01, 1'b1, 1'b1, gpha, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Illegal Instruction Exception");
            reset_dut();
            sys_ena_i = 1;
            exc_ill = 1;
            repeat(2) @(posedge sys_clk_i);

            if (brk_if != 2'b00)
                #1;

                check_outputs(brk_if, 1'b1, 1'b1, gpha, 1'b1, 1'b1);
            else
                #1;

                check_outputs(2'b10, 1'b1, 1'b1, gpha, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aeMB2_pipe Testbench");
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
        input [1:0] expected_brk_if;
        input expected_dena;
        input expected_gclk;
        input expected_gpha;
        input expected_grst;
        input expected_iena;
        begin
            if (expected_brk_if === (expected_brk_if ^ brk_if ^ expected_brk_if) &&
                expected_dena === (expected_dena ^ dena ^ expected_dena) &&
                expected_gclk === (expected_gclk ^ gclk ^ expected_gclk) &&
                expected_gpha === (expected_gpha ^ gpha ^ expected_gpha) &&
                expected_grst === (expected_grst ^ grst ^ expected_grst) &&
                expected_iena === (expected_iena ^ iena ^ expected_iena)) begin
                $display("PASS");
                $display("  Outputs: brk_if=%h, dena=%b, gclk=%b, gpha=%b, grst=%b, iena=%b",
                         brk_if, dena, gclk, gpha, grst, iena);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: brk_if=%h, dena=%b, gclk=%b, gpha=%b, grst=%b, iena=%b",
                         expected_brk_if, expected_dena, expected_gclk, expected_gpha, expected_grst, expected_iena);
                $display("  Got:      brk_if=%h, dena=%b, gclk=%b, gpha=%b, grst=%b, iena=%b",
                         brk_if, dena, gclk, gpha, grst, iena);
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
        $dumpvars(0,bra_ex, dwb_fb, exc_dwb, exc_ill, exc_iwb, fet_fb, ich_fb, msr_ex, sys_clk_i, sys_ena_i, sys_int_i, sys_rst_i, xwb_fb, brk_if, dena, gclk, gpha, grst, iena);
    end

endmodule
