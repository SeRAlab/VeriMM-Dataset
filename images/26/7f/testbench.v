`timescale 1ns/1ps

module dram_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg we;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_4bit dut (
        .clk(clk),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            data_in = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Writing 4'hA (1010)");
            we = 1;
            data_in = 4'hA;
            @(posedge clk);
            #1;
            we = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Testing persistence. Write 4'h5, then disable 'we' and change 'data_in'");

            we = 1;
            data_in = 4'h5;
            @(posedge clk);
            #1;

            we = 0;
            data_in = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Successive writes. Update 4'h3 -> 4'hC");
            we = 1;
            data_in = 4'h3;
            @(posedge clk);
            #1;
            data_in = 4'hC;
            @(posedge clk);
            #1;
            we = 0;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Write all zeros");
            we = 1;
            data_in = 4'b0000;
            @(posedge clk);
            #1;
            we = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Write all ones");
            we = 1;
            data_in = 4'b1111;
            @(posedge clk);
            #1;
            we = 0;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Change 'we' and 'data_in' between clock edges");
            we = 1;
            data_in = 4'h7;
            @(posedge clk);
            #1;
            we = 0;
            data_in = 4'hE;
            #2;
            we = 1;
            #2;
            we = 0;
            #1;

            check_outputs(4'h7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_4bit Testbench");
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
        $dumpvars(0,clk, data_in, we, data_out);
    end

endmodule
