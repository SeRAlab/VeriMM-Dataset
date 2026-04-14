`timescale 1ns/1ps

module register_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr_n;
    reg [31:0] d;
    reg en;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_32bit dut (
        .clk(clk),
        .clr_n(clr_n),
        .d(d),
        .en(en),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clr_n = 0;
        en = 0;
        d = 32'h0;
        @(negedge clk);
        clr_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Asynchronous Reset", test_num);
        reset_dut();


        #1;



        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Load 32-bit value (Enable=1)", test_num);
        reset_dut();
        d = 32'hDEADBEEF;
        en = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Data retention (Enable=0)", test_num);
        reset_dut();

        d = 32'h12345678;
        en = 1;
        @(posedge clk);
        #1;

        en = 0;
        d = 32'hFFFFFFFF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Load all ones", test_num);
        reset_dut();
        d = 32'hFFFFFFFF;
        en = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Async Clear priority", test_num);
        reset_dut();

        d = 32'hAAAA5555;
        en = 1;
        @(posedge clk);
        #1;

        clr_n = 0;
        #2;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Repeated updates", test_num);
        reset_dut();
        en = 1;
        d = 32'h1;
        @(posedge clk);
        d = 32'h2;
        @(posedge clk);
        d = 32'h3;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000003);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_32bit Testbench");
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
        input [31:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, clr_n, d, en, q);
    end

endmodule
