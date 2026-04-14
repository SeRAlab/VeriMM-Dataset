`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg read_en;
    reg write_en;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .data_in(data_in),
        .read_en(read_en),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 16'h0000;
            read_en = 0;
            write_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            data_in = 16'hAAAA;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;


            read_en = 1;
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            data_in = 16'h5555;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;


            read_en = 1;
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            data_in = 16'hFFFF;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;

            read_en = 1;
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            data_in = 16'h1234;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;


            repeat(3) @(posedge clk);
            #1;


            read_en = 1;
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            data_in = 16'hCAFE;
            write_en = 1;
            @(posedge clk);
            #1;


            data_in = 16'hBEEF;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;


            read_en = 1;
            #1;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            data_in = 16'h7777;
            write_en = 1;
            @(posedge clk);
            #1;
            write_en = 0;


            data_in = 16'h8888;
            @(posedge clk);
            #1;


            read_en = 1;
            #1;
            #1;

            check_outputs(16'h7777);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, read_en, write_en, data_out);
    end

endmodule
