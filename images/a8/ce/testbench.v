`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addra;
    reg clk;
    reg [31:0] dina;
    reg rst;
    reg wea;
    wire [31:0] douta;
    wire [7:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .clk(clk),
        .dina(dina),
        .rst(rst),
        .wea(wea),
        .douta(douta),
        .led(led)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        wea = 0;
        addra = 0;
        dina = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset State Verification", test_num);
        reset_dut();

        addra = 4'h0;
        @(posedge clk);
        #1 #1;
 check_outputs(32'h0, 8'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write to Address 0 (LED check)", test_num);
        reset_dut();

        @(posedge clk);
        wea = 1;
        addra = 4'h0;
        dina = 32'hABCDEFAA;
        @(posedge clk);
        wea = 0;


        #1 #1;
 check_outputs(32'hABCDEFAA, 8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write to Address 5, Verify LED remains Register 0", test_num);
        reset_dut();


        wea = 1;
        addra = 4'h0;
        dina = 32'h00000055;
        @(posedge clk);


        addra = 4'h5;
        dina = 32'h12345678;
        @(posedge clk);
        wea = 0;


        #1 #1;
 check_outputs(32'h12345678, 8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Enable (WEA) check", test_num);
        reset_dut();


        wea = 0;
        addra = 4'hA;
        dina = 32'hFFFFFFFF;
        @(posedge clk);


        #1 #1;
 check_outputs(32'h0, 8'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Address (15) check", test_num);
        reset_dut();

        wea = 1;
        addra = 4'hF;
        dina = 32'h55AA55AA;
        @(posedge clk);
        wea = 0;


        #1 #1;
 check_outputs(32'h55AA55AA, 8'h00);
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
        input [31:0] expected_douta;
        input [7:0] expected_led;
        begin
            if (expected_douta === (expected_douta ^ douta ^ expected_douta) &&
                expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: douta=%h, led=%h",
                         douta, led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: douta=%h, led=%h",
                         expected_douta, expected_led);
                $display("  Got:      douta=%h, led=%h",
                         douta, led);
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
        $dumpvars(0,addra, clk, dina, rst, wea, douta, led);
    end

endmodule
