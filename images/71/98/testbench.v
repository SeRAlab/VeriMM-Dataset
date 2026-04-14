`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] Address;
    reg Clk;
    reg Cs;
    reg Iow;
    reg Reset;
    reg [15:0] Wdata;
    wire [7:0] led_high;
    wire [15:0] leds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .Clk(Clk),
        .Cs(Cs),
        .Iow(Iow),
        .Reset(Reset),
        .Wdata(Wdata),
        .led_high(led_high),
        .leds(leds)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            Address = 0;
            Cs = 0;
            Iow = 0;
            Wdata = 0;
            @(posedge Clk);
            #1 Reset = 0;
            @(posedge Clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(led_high, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write 0xABCD to Address 0", test_num);
            reset_dut();
            Address = 3'd0; Cs = 1; Iow = 1; Wdata = 16'hABCD;
            @(posedge Clk);
            #1 Cs = 0; Iow = 0;
            #1;

            check_outputs(led_high, 16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write 0x55 to Address 2 (led_high)", test_num);
            reset_dut();
            Address = 3'd2; Cs = 1; Iow = 1; Wdata = 16'h1255;
            @(posedge Clk);
            #1 Cs = 0; Iow = 0;
            #1;

            check_outputs(8'h55, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Successive writes to Address 0 and Address 2", test_num);
            reset_dut();

            Address = 3'd0; Cs = 1; Iow = 1; Wdata = 16'hAAAA;
            @(posedge Clk);

            #1 Address = 3'd2; Wdata = 16'hBB33;
            @(posedge Clk);
            #1 Cs = 0; Iow = 0;
            #1;

            check_outputs(8'h33, 16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Cs inhibits write", test_num);
            reset_dut();

            Address = 3'd0; Cs = 0; Iow = 1; Wdata = 16'hFFFF;
            @(posedge Clk);
            #1 #1;
 check_outputs(led_high, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Iow inhibits write", test_num);
            reset_dut();

            Address = 3'd0; Cs = 1; Iow = 0; Wdata = 16'hFFFF;
            @(posedge Clk);
            #1 #1;
 check_outputs(led_high, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify invalid address (Address 1) does not change leds", test_num);
            reset_dut();

            Address = 3'd0; Cs = 1; Iow = 1; Wdata = 16'h1234;
            @(posedge Clk);

            #1 Address = 3'd1; Wdata = 16'hFFFF;
            @(posedge Clk);
            #1 Cs = 0; Iow = 0;
            #1;

            check_outputs(led_high, 16'h1234);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Address 0 does not change led_high", test_num);
            reset_dut();

            Address = 3'd2; Cs = 1; Iow = 1; Wdata = 16'h00FF;
            @(posedge Clk);

            #1 Address = 3'd0; Wdata = 16'h5555;
            @(posedge Clk);
            #1 Cs = 0; Iow = 0;
            #1;

            check_outputs(8'hFF, 16'h5555);
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
        input [7:0] expected_led_high;
        input [15:0] expected_leds;
        begin
            if (expected_led_high === (expected_led_high ^ led_high ^ expected_led_high) &&
                expected_leds === (expected_leds ^ leds ^ expected_leds)) begin
                $display("PASS");
                $display("  Outputs: led_high=%h, leds=%h",
                         led_high, leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_high=%h, leds=%h",
                         expected_led_high, expected_leds);
                $display("  Got:      led_high=%h, leds=%h",
                         led_high, leds);
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
        $dumpvars(0,Address, Clk, Cs, Iow, Reset, Wdata, led_high, leds);
    end

endmodule
