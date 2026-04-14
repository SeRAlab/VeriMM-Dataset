`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [15:0] data_out;

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
            write_enable <= 0;
            read_enable <= 0;
            data_in <= 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            data_in <= 16'hAAAA;
            write_enable <= 1;
            @(posedge clk);
            #1;
            write_enable <= 0;


            read_enable <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Alternative Value Write/Read", test_num);
            reset_dut();


            data_in <= 16'h5555;
            write_enable <= 1;
            @(posedge clk);
            #1;
            write_enable <= 0;


            read_enable <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Data Persistence Check", test_num);
            reset_dut();


            data_in <= 16'h1234;
            write_enable <= 1;
            @(posedge clk);
            #1;
            write_enable <= 0;
            data_in <= 16'hFFFF;


            repeat(2) @(posedge clk);
            #1;


            read_enable <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Overwrite Data Check", test_num);
            reset_dut();


            data_in <= 16'hBEEF;
            write_enable <= 1;
            @(posedge clk);
            #1;


            data_in <= 16'hCAFE;
            write_enable <= 1;
            @(posedge clk);
            #1;
            write_enable <= 0;


            read_enable <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hCAFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Write Enable Inhibit Check", test_num);
            reset_dut();


            data_in <= 16'h7777;
            write_enable <= 1;
            @(posedge clk);
            #1;
            write_enable <= 0;


            data_in <= 16'h8888;
            write_enable <= 0;
            @(posedge clk);
            #1;


            read_enable <= 1;
            @(posedge clk);
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
        $dumpvars(0,clk, data_in, read_enable, write_enable, data_out);
    end

endmodule
