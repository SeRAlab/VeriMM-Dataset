`timescale 1ns/1ps

module loadable_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg mode;
    reg [3:0] preset_value;
    reg rst_n;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    loadable_counter dut (
        .clk(clk),
        .load(load),
        .mode(mode),
        .preset_value(preset_value),
        .rst_n(rst_n),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load = 0;
            mode = 0;
            preset_value = 0;
            @(negedge clk);
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Synchronous Load Check");
            reset_dut();
            load = 1;
            preset_value = 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Count Up Check (0 to 5)");
            reset_dut();
            load = 0;
            mode = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Count Down Check (Load 8 then down 3 steps)");
            reset_dut();
            load = 1;
            preset_value = 4'h8;
            @(posedge clk);
            load = 0;
            mode = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Roll-over Up Check");
            reset_dut();
            load = 1;
            preset_value = 4'hF;
            @(posedge clk);
            load = 0;
            mode = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Roll-under Down Check");
            reset_dut();
            load = 0;
            mode = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Load Priority Check");
            reset_dut();
            load = 1;
            preset_value = 4'hC;
            mode = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Mode Switching Check");
            reset_dut();
            load = 0;
            mode = 0;
            repeat(3) @(posedge clk);
            mode = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: Load Zero Check");
            reset_dut();
            load = 1;
            preset_value = 4'hE;
            @(posedge clk);
            preset_value = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase010;

        begin
            $display("Running testcase010: Full Cycle Up Check (16 clocks)");
            reset_dut();
            load = 0;
            mode = 0;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("loadable_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, load, mode, preset_value, rst_n, count);
    end

endmodule
