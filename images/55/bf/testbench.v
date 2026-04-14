`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg mclock;
    reg ram_sel;
    reg rstn;
    reg tex_push_en;
    wire ram_wen_hi;
    wire ram_wen_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mclock(mclock),
        .ram_sel(ram_sel),
        .rstn(rstn),
        .tex_push_en(tex_push_en),
        .ram_wen_hi(ram_wen_hi),
        .ram_wen_lo(ram_wen_lo)
    );

    // Clock generation (10ns period)
    initial begin
        mclock = 0;
        forever #5 mclock = ~mclock;
    end

        task reset_dut;

    begin
        rstn = 0;
        tex_push_en = 0;
        ram_sel = 0;
        repeat(2) @(posedge mclock);
        #1 rstn = 1;
        repeat(1) @(posedge mclock);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Post-reset idle check (tex_push_en=0)", test_num);
        tex_push_en = 0;
        ram_sel = 0;
        #2;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: State 0 write (tex_push_en=1, ram_sel=0)", test_num);
        tex_push_en = 1;
        ram_sel = 0;
        #2;

        #1;


        check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: State 1 write (After 1 toggle, tex_push_en=1)", test_num);

        tex_push_en = 1;
        ram_sel = 0;
        @(posedge mclock);
        #2;

        #1;


        check_outputs(1, 0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: ram_sel inhibition check in State 0", test_num);
        tex_push_en = 1;
        ram_sel = 1;
        #2;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Full state toggle sequence check", test_num);


        tex_push_en = 1;
        ram_sel = 0;
        @(posedge mclock);


        @(posedge mclock);


        #2;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: No state toggle when push_en=0", test_num);


        tex_push_en = 0;
        repeat(2) @(posedge mclock);


        tex_push_en = 1;
        ram_sel = 0;
        #2;
        #1;

        check_outputs(0, 1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_ram_wen_hi;
        input expected_ram_wen_lo;
        begin
            if (expected_ram_wen_hi === (expected_ram_wen_hi ^ ram_wen_hi ^ expected_ram_wen_hi) &&
                expected_ram_wen_lo === (expected_ram_wen_lo ^ ram_wen_lo ^ expected_ram_wen_lo)) begin
                $display("PASS");
                $display("  Outputs: ram_wen_hi=%b, ram_wen_lo=%b",
                         ram_wen_hi, ram_wen_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ram_wen_hi=%b, ram_wen_lo=%b",
                         expected_ram_wen_hi, expected_ram_wen_lo);
                $display("  Got:      ram_wen_hi=%b, ram_wen_lo=%b",
                         ram_wen_hi, ram_wen_lo);
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
        $dumpvars(0,mclock, ram_sel, rstn, tex_push_en, ram_wen_hi, ram_wen_lo);
    end

endmodule
