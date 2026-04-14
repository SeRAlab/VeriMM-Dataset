`timescale 1ns/1ps

module SRAM_16bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
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
    SRAM_16bit dut (
        .address(address),
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
            address = 0;
            data_in = 0;
            read_enable = 0;
            write_enable = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read at Address 0", test_num);


            address = 4'h0;
            data_in = 16'hABCD;
            write_enable = 1;
            read_enable = 0;
            @(posedge clk);


            #2;
            write_enable = 0;
            read_enable = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Boundary Address (Address 15)", test_num);


            address = 4'hF;
            data_in = 16'h55AA;
            write_enable = 1;
            read_enable = 0;
            @(posedge clk);


            #2;
            write_enable = 0;
            read_enable = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Overwriting Data at Address 5", test_num);


            address = 4'h5;
            data_in = 16'h1111;
            write_enable = 1;
            @(posedge clk);


            #2;
            data_in = 16'h2222;
            @(posedge clk);


            #2;
            write_enable = 0;
            read_enable = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Write Enable Logic Check", test_num);


            address = 4'hA;
            data_in = 16'h7777;
            write_enable = 1;
            @(posedge clk);


            #2;
            write_enable = 0;
            data_in = 16'hEEEE;
            @(posedge clk);


            #2;
            read_enable = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h7777);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Multiple Address Data Integrity", test_num);


            address = 4'h2; data_in = 16'hAAAA; write_enable = 1;
            @(posedge clk);
            #2;

            address = 4'h8; data_in = 16'hBBBB; write_enable = 1;
            @(posedge clk);
            #2;


            write_enable = 0;
            read_enable = 1;
            address = 4'h2;
            @(posedge clk);
            #2;


            #1;



            check_outputs(16'hAAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_16bit Testbench");
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
        $dumpvars(0,address, clk, data_in, read_enable, write_enable, data_out);
    end

endmodule
