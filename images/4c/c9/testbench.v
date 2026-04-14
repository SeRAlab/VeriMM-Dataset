`timescale 1ns/1ps

module security_gate_controller_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg close_signal;
    reg open_signal;
    wire gate_open;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    security_gate_controller dut (
        .areset(areset),
        .clk(clk),
        .close_signal(close_signal),
        .open_signal(open_signal),
        .gate_open(gate_open)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            open_signal = 0;
            close_signal = 0;
            #12;
            areset = 0;
            #8;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Closed -> Open via open_signal", test_num);
            reset_dut();
            @(posedge clk);
            open_signal = 1;
            @(posedge clk);
            open_signal = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Open -> Closed via close_signal", test_num);
            reset_dut();

            @(posedge clk);
            open_signal = 1;
            @(posedge clk);
            open_signal = 0;

            @(posedge clk);
            close_signal = 1;
            @(posedge clk);
            close_signal = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Stay Open if close_signal is 0", test_num);
            reset_dut();
            @(posedge clk);
            open_signal = 1;
            @(posedge clk);
            open_signal = 0;
            close_signal = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Stay Closed if open_signal is 0", test_num);
            reset_dut();
            @(posedge clk);
            open_signal = 0;
            close_signal = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Full cycle sequence", test_num);
            reset_dut();

            @(posedge clk);
            open_signal = 1;
            @(posedge clk);
            open_signal = 0;

            @(posedge clk);
            close_signal = 1;
            @(posedge clk);
            close_signal = 0;

            @(posedge clk);
            open_signal = 1;
            @(posedge clk);
            open_signal = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("security_gate_controller Testbench");
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
        input expected_gate_open;
        begin
            if (expected_gate_open === (expected_gate_open ^ gate_open ^ expected_gate_open)) begin
                $display("PASS");
                $display("  Outputs: gate_open=%b",
                         gate_open);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gate_open=%b",
                         expected_gate_open);
                $display("  Got:      gate_open=%b",
                         gate_open);
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
        $dumpvars(0,areset, clk, close_signal, open_signal, gate_open);
    end

endmodule
