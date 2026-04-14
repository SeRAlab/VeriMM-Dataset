`timescale 1ns/1ps

module cop_count_tb;

    // Testbench signals (sequential circuit)
    reg async_rst_b;
    reg bus_clk;
    reg clear_event;
    reg cop_ena;
    reg [1:0] cop_irq_en;
    reg debug_ena;
    reg debug_mode_i;
    reg por_reset_i;
    reg reload_count;
    reg scantestmode;
    reg startup_osc_i;
    reg stop_ena;
    reg stop_mode_i;
    reg sync_reset;
    reg [15:0] timeout_value;
    reg wait_ena;
    reg wait_mode_i;
    wire [15:0] cop_capture;
    wire [15:0] cop_counter;
    wire cop_event;
    wire cop_irq_o;
    wire cop_rst_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cop_count dut (
        .async_rst_b(async_rst_b),
        .bus_clk(bus_clk),
        .clear_event(clear_event),
        .cop_ena(cop_ena),
        .cop_irq_en(cop_irq_en),
        .debug_ena(debug_ena),
        .debug_mode_i(debug_mode_i),
        .por_reset_i(por_reset_i),
        .reload_count(reload_count),
        .scantestmode(scantestmode),
        .startup_osc_i(startup_osc_i),
        .stop_ena(stop_ena),
        .stop_mode_i(stop_mode_i),
        .sync_reset(sync_reset),
        .timeout_value(timeout_value),
        .wait_ena(wait_ena),
        .wait_mode_i(wait_mode_i),
        .cop_capture(cop_capture),
        .cop_counter(cop_counter),
        .cop_event(cop_event),
        .cop_irq_o(cop_irq_o),
        .cop_rst_o(cop_rst_o)
    );

    // Clock generation (10ns period)
    initial begin
        async_rst_b = 0;
        forever #5 async_rst_b = ~async_rst_b;
    end

        task reset_dut;

        begin
            async_rst_b   = 0;
            por_reset_i   = 0;
            sync_reset    = 0;
            bus_clk       = 0;
            reload_count  = 0;
            clear_event   = 0;
            debug_mode_i  = 0;
            debug_ena     = 0;
            wait_ena      = 0;
            wait_mode_i   = 0;
            stop_ena      = 0;
            stop_mode_i   = 0;
            cop_ena       = 0;
            cop_irq_en    = 2'b00;
            timeout_value = 16'h0000;
            scantestmode  = 0;
            #20;
            async_rst_b   = 1;
            por_reset_i   = 1;
            #20;
            @(posedge bus_clk);
            sync_reset    = 1;
            @(posedge bus_clk);
            sync_reset    = 0;
            @(posedge bus_clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Counter Increment");
            reset_dut();
            test_num = 1;

            timeout_value = 16'h0050;
            cop_ena = 1;


            repeat(10) @(posedge bus_clk);


            #1;



            check_outputs(16'h0000, 16'h000A, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Watchdog Timeout Reset");
            reset_dut();
            test_num = 2;

            timeout_value = 16'h0008;
            cop_ena = 1;


            repeat(12) @(posedge bus_clk);




            #1;





            check_outputs(16'h0000, 16'h0008, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Reload/Kick Mechanism");
            reset_dut();
            test_num = 3;

            timeout_value = 16'h0010;
            cop_ena = 1;

            repeat(8) @(posedge bus_clk);

            reload_count = 1;
            @(posedge bus_clk);
            reload_count = 0;

            repeat(4) @(posedge bus_clk);


            #1;



            check_outputs(16'h0000, 16'h0004, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Interrupt Generation");
            reset_dut();
            test_num = 4;

            timeout_value = 16'h0005;
            cop_irq_en = 2'b01;
            cop_ena = 1;

            repeat(7) @(posedge bus_clk);


            #1;



            check_outputs(16'h0000, 16'h0005, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Event Clearing");
            reset_dut();
            test_num = 5;

            timeout_value = 16'h0005;
            cop_ena = 1;

            repeat(7) @(posedge bus_clk);

            clear_event = 1;
            @(posedge bus_clk);
            clear_event = 0;
            @(posedge bus_clk);


            #1;



            check_outputs(16'h0000, 16'h0005, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Stop Mode Inhibition");
            reset_dut();
            test_num = 6;

            timeout_value = 16'h0020;
            cop_ena = 1;
            stop_ena = 1;

            repeat(5) @(posedge bus_clk);

            stop_mode_i = 1;
            repeat(10) @(posedge bus_clk);


            #1;



            check_outputs(16'h0000, 16'h0005, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Wait Mode Inhibition");
            reset_dut();
            test_num = 7;

            timeout_value = 16'h0020;
            cop_ena = 1;
            wait_ena = 1;

            repeat(5) @(posedge bus_clk);

            wait_mode_i = 1;
            repeat(10) @(posedge bus_clk);


            #1;



            check_outputs(16'h0000, 16'h0005, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning testcase008: Debug Mode Inhibition");
            reset_dut();
            test_num = 8;

            timeout_value = 16'h0020;
            cop_ena = 1;
            debug_ena = 1;

            repeat(5) @(posedge bus_clk);

            debug_mode_i = 1;
            repeat(10) @(posedge bus_clk);


            #1;



            check_outputs(16'h0000, 16'h0005, 1'b0, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cop_count Testbench");
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
        input [15:0] expected_cop_capture;
        input [15:0] expected_cop_counter;
        input expected_cop_event;
        input expected_cop_irq_o;
        input expected_cop_rst_o;
        begin
            if (expected_cop_capture === (expected_cop_capture ^ cop_capture ^ expected_cop_capture) &&
                expected_cop_counter === (expected_cop_counter ^ cop_counter ^ expected_cop_counter) &&
                expected_cop_event === (expected_cop_event ^ cop_event ^ expected_cop_event) &&
                expected_cop_irq_o === (expected_cop_irq_o ^ cop_irq_o ^ expected_cop_irq_o) &&
                expected_cop_rst_o === (expected_cop_rst_o ^ cop_rst_o ^ expected_cop_rst_o)) begin
                $display("PASS");
                $display("  Outputs: cop_capture=%h, cop_counter=%h, cop_event=%b, cop_irq_o=%b, cop_rst_o=%b",
                         cop_capture, cop_counter, cop_event, cop_irq_o, cop_rst_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cop_capture=%h, cop_counter=%h, cop_event=%b, cop_irq_o=%b, cop_rst_o=%b",
                         expected_cop_capture, expected_cop_counter, expected_cop_event, expected_cop_irq_o, expected_cop_rst_o);
                $display("  Got:      cop_capture=%h, cop_counter=%h, cop_event=%b, cop_irq_o=%b, cop_rst_o=%b",
                         cop_capture, cop_counter, cop_event, cop_irq_o, cop_rst_o);
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
        $dumpvars(0,async_rst_b, bus_clk, clear_event, cop_ena, cop_irq_en, debug_ena, debug_mode_i, por_reset_i, reload_count, scantestmode, startup_osc_i, stop_ena, stop_mode_i, sync_reset, timeout_value, wait_ena, wait_mode_i, cop_capture, cop_counter, cop_event, cop_irq_o, cop_rst_o);
    end

endmodule
