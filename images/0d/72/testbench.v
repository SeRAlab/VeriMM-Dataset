`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg shift;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift(shift),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load <= 1;
            shift <= 0;
            data_in <= 4'b0000;
            @(posedge clk);
            load <= 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Load 4'b1010");
            reset_dut();
            @(posedge clk);
            load <= 1;
            shift <= 0;
            data_in <= 4'b1010;
            @(posedge clk);
            load <= 0;
            #1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load 4'b1100 and Shift Right Once");
            reset_dut();
            @(posedge clk);
            load <= 1;
            data_in <= 4'b1100;
            @(posedge clk);
            load <= 0;
            shift <= 1;
            @(posedge clk);
            shift <= 0;
            #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load 4'b0101 and Hold");
            reset_dut();
            @(posedge clk);
            load <= 1;
            data_in <= 4'b0101;
            @(posedge clk);
            load <= 0;
            shift <= 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Load 4'b1000 and Shift Right 3 Times");
            reset_dut();
            @(posedge clk);
            load <= 1;
            data_in <= 4'b1000;
            @(posedge clk);
            load <= 0;
            shift <= 1;
            repeat(3) @(posedge clk);
            shift <= 0;
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Load Priority (Load=1, Shift=1)");
            reset_dut();
            @(posedge clk);
            load <= 1;
            data_in <= 4'b1111;
            @(posedge clk);

            load <= 1;
            shift <= 1;
            data_in <= 4'b1010;
            @(posedge clk);
            load <= 0;
            shift <= 0;
            #1;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift 4'b1111 out completely");
            reset_dut();
            @(posedge clk);
            load <= 1;
            data_in <= 4'b1111;
            @(posedge clk);
            load <= 0;
            shift <= 1;
            repeat(4) @(posedge clk);
            shift <= 0;
            #1;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
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
        $dumpvars(0,clk, data_in, load, shift, data_out);
    end

endmodule
