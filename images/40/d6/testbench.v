`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rd;
    reg wr;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .clk(clk),
        .data_in(data_in),
        .rd(rd),
        .wr(wr),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            wr = 0;
            rd = 0;
            data_in = 4'b0000;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read (0xA)", test_num);


            @(negedge clk);
            wr = 1; rd = 0; data_in = 4'hA;
            @(negedge clk);
            wr = 0;


            @(negedge clk);
            rd = 1;
            @(negedge clk);

            #1;


            check_outputs(4'hA);
            rd = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Basic Write and Read (0x5)", test_num);


            @(negedge clk);
            wr = 1; rd = 0; data_in = 4'h5;
            @(negedge clk);
            wr = 0;


            @(negedge clk);
            rd = 1;
            @(negedge clk);

            #1;


            check_outputs(4'h5);
            rd = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Data Retention Check", test_num);


            @(negedge clk);
            wr = 1; rd = 0; data_in = 4'hC;
            @(negedge clk);
            wr = 0;


            repeat(3) @(negedge clk);


            rd = 1;
            @(negedge clk);

            #1;


            check_outputs(4'hC);
            rd = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Overwrite Check", test_num);


            @(negedge clk);
            wr = 1; rd = 0; data_in = 4'h1;
            @(negedge clk);


            wr = 1; rd = 0; data_in = 4'hE;
            @(negedge clk);
            wr = 0;


            rd = 1;
            @(negedge clk);

            #1;


            check_outputs(4'hE);
            rd = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Boundary Values (0xF)", test_num);


            @(negedge clk);
            wr = 1; rd = 0; data_in = 4'hF;
            @(negedge clk);
            wr = 0;


            rd = 1;
            @(negedge clk);

            #1;


            check_outputs(4'hF);
            rd = 0;
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: No Write When wr=0", test_num);


            @(negedge clk);
            wr = 1; rd = 0; data_in = 4'h7;
            @(negedge clk);


            wr = 0; rd = 0; data_in = 4'h3;
            @(negedge clk);


            rd = 1;
            @(negedge clk);


            #1;



            check_outputs(4'h7);
            rd = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        $dumpvars(0,clk, data_in, rd, wr, data_out);
    end

endmodule
