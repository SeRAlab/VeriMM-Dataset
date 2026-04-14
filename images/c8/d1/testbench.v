`timescale 1ns/1ps

module clock_gate_en_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg en;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_gate_en dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            data_in = 0;

            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: en=0, clk=1, data_in=1 -> Expected data_out=0");
            reset_dut();
            en = 0;
            data_in = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: en=1, clk=0, data_in=1 -> Expected data_out=0");
            reset_dut();
            en = 1;
            data_in = 1;

            @(negedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: en=1, clk=1, data_in=0 -> Expected data_out=0");
            reset_dut();
            en = 1;
            data_in = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: en=1, clk=1, data_in=1 -> Expected data_out=1");
            reset_dut();
            en = 1;
            data_in = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Dynamic data transition (1->0) during en=1, clk=1");
            reset_dut();
            en = 1;
            data_in = 1;
            @(posedge clk);
            #2;
            data_in = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase006: Dynamic enable transition (1->0) during clk=1, data=1");
            reset_dut();
            en = 1;
            data_in = 1;
            @(posedge clk);
            #2;
            en = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_gate_en Testbench");
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
                         data_out);
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
        $dumpvars(0,clk, data_in, en, data_out);
    end

endmodule
