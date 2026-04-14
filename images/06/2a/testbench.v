`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .control(control),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test 001: Write and Read 0xAA");


            @(negedge clk);
            data_in = 8'hAA;
            control = 1;
            @(posedge clk);
            #1;


            @(negedge clk);
            control = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test 002: Write and Read 0x55");


            @(negedge clk);
            data_in = 8'h55;
            control = 1;
            @(posedge clk);
            #1;


            @(negedge clk);
            control = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test 003: Overwrite existing data");


            @(negedge clk);
            data_in = 8'h11;
            control = 1;
            @(posedge clk);
            #1;


            @(negedge clk);
            data_in = 8'hEE;
            control = 1;
            @(posedge clk);
            #1;


            @(negedge clk);
            control = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hEE);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test 004: Data persistence over multiple cycles");


            @(negedge clk);
            data_in = 8'hBC;
            control = 1;
            @(posedge clk);
            #1;


            @(negedge clk);
            control = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hBC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test 005: Write and Read 0xFF");

            @(negedge clk);
            data_in = 8'hFF;
            control = 1;
            @(posedge clk);
            #1;

            @(negedge clk);
            control = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test 006: Write and Read 0x00");

            @(negedge clk);
            data_in = 8'h00;
            control = 1;
            @(posedge clk);
            #1;

            @(negedge clk);
            control = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, control, data_in, data_out);
    end

endmodule
