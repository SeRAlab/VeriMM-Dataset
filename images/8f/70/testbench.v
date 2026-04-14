`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] load_value;
    reg rst_n;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .rst_n(rst_n),
        .Q(Q)
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
            load_value = 0;
            #10;
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

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Parallel Load Check");
            reset_dut();
            load = 1;
            load_value = 16'hA5A5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Single Bit Shift Left");
            reset_dut();

            load = 1;
            load_value = 16'h0001;
            @(posedge clk);

            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Multiple Bit Shift Left");
            reset_dut();
            load = 1;
            load_value = 16'h000F;
            @(posedge clk);
            load = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Shift Overflow Check");
            reset_dut();
            load = 1;
            load_value = 16'h8000;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Load Precedence Check");
            reset_dut();
            load = 1;
            load_value = 16'h1234;
            @(posedge clk);

            load = 1;
            load_value = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Full Clear via Shifting");
            reset_dut();
            load = 1;
            load_value = 16'hFFFF;
            @(posedge clk);
            load = 0;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Alternating Load and Shift");
            reset_dut();
            load = 1;
            load_value = 16'h5555;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            load = 1;
            load_value = 16'h1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [15:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clk, load, load_value, rst_n, Q);
    end

endmodule
