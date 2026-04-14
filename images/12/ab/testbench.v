`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .data_in(data_in),
        .read_enable(read_enable),
        .write_enable(write_enable),
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
            write_enable = 0;
            read_enable = 0;
            data_in = 4'b0000;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Write and Read (4'hA)");
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            data_in = 4'hA;
            @(negedge clk);
            write_enable = 0;


            read_enable = 1;
            @(negedge clk);

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Data Retention after 3 cycles");
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            data_in = 4'h5;
            @(negedge clk);
            write_enable = 0;


            repeat(3) @(negedge clk);


            read_enable = 1;
            @(negedge clk);

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Overwriting Data (4'hF to 4'h3)");
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            data_in = 4'hF;
            @(negedge clk);


            data_in = 4'h3;
            @(negedge clk);
            write_enable = 0;


            read_enable = 1;
            @(negedge clk);

            #1;


            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Output Gating when Read Enable is 0");
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            data_in = 4'hC;
            @(negedge clk);
            write_enable = 0;


            read_enable = 0;
            @(negedge clk);



            #1;




            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Writing and Reading 4'h0");
            reset_dut();


            @(negedge clk);
            write_enable = 1;
            data_in = 4'h0;
            @(negedge clk);
            write_enable = 0;


            read_enable = 1;
            @(negedge clk);

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Simultaneous Write and Read");
            reset_dut();

            @(negedge clk);
            write_enable = 1;
            read_enable = 1;
            data_in = 4'h9;
            @(negedge clk);


            #1;



            check_outputs(4'h9);
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
        $dumpvars(0,clk, data_in, read_enable, write_enable, data_out);
    end

endmodule
