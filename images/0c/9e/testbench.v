`timescale 1ns/1ps

module SRAM_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg enable;
    reg [1:0] select;
    reg write;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_4bit dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .select(select),
        .write(write),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            write = 0;
            select = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read (Addr 0)", test_num);
            reset_dut();


            enable = 1;
            write = 1;
            select = 2'b00;
            data_in = 4'hA;
            @(posedge clk);
            #1;


            write = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read (Addr 3)", test_num);
            reset_dut();


            enable = 1;
            write = 1;
            select = 2'b11;
            data_in = 4'h5;
            @(posedge clk);
            #1;


            write = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable Signal Check (Disable Write)", test_num);
            reset_dut();


            enable = 0;
            write = 1;
            select = 2'b01;
            data_in = 4'hF;
            @(posedge clk);
            #1;


            enable = 1;
            write = 0;
            select = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Persistence/Select Logic", test_num);
            reset_dut();

            enable = 1;


            write = 1; select = 2'b00; data_in = 4'h1; @(posedge clk); #1;

            write = 1; select = 2'b01; data_in = 4'h2; @(posedge clk); #1;

            write = 1; select = 2'b10; data_in = 4'h4; @(posedge clk); #1;

            write = 1; select = 2'b11; data_in = 4'h8; @(posedge clk); #1;


            write = 0;
            select = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwrite Check", test_num);
            reset_dut();

            enable = 1;


            write = 1; select = 2'b10; data_in = 4'h7; @(posedge clk); #1;


            write = 1; select = 2'b10; data_in = 4'hE; @(posedge clk); #1;


            write = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read Disable Check", test_num);
            reset_dut();


            enable = 1; write = 1; select = 2'b00; data_in = 4'hB; @(posedge clk); #1;


            enable = 0; write = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_4bit Testbench");
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
        $dumpvars(0,clk, data_in, enable, select, write, data_out);
    end

endmodule
