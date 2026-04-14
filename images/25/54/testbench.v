`timescale 1ns/1ps

module SRAM_4bit_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg clk;
    reg [3:0] data_in;
    reg we;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_4bit dut (
        .addr(addr),
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
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Write/Read Address 0", test_num);
            reset_dut();


            we = 1;
            addr = 2'b00;
            data_in = 4'hA;
            @(posedge clk);
            #2;


            we = 0;
            addr = 2'b00;
            #2;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write/Read Address 3", test_num);
            reset_dut();


            we = 1;
            addr = 2'b11;
            data_in = 4'h5;
            @(posedge clk);
            #2;


            we = 0;
            addr = 2'b11;
            #2;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Overwrite data at Address 1", test_num);
            reset_dut();


            we = 1;
            addr = 2'b01;
            data_in = 4'h1;
            @(posedge clk);
            #2;


            data_in = 4'hE;
            @(posedge clk);
            #2;


            we = 0;
            #2;

            #1;


            check_outputs(4'hE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Data persistence across multiple writes", test_num);
            reset_dut();


            we = 1; addr = 2'b00; data_in = 4'h7;
            @(posedge clk); #2;


            we = 1; addr = 2'b01; data_in = 4'hB;
            @(posedge clk); #2;


            we = 0; addr = 2'b00;
            #2;

            #1;


            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Verify WE functionality (Read-only mode)", test_num);
            reset_dut();


            we = 1; addr = 2'b10; data_in = 4'h3;
            @(posedge clk); #2;


            we = 0; addr = 2'b10; data_in = 4'hF;
            @(posedge clk); #2;


            #2;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Fill all addresses", test_num);
            reset_dut();


            we = 1; addr = 2'b00; data_in = 4'h0; @(posedge clk); #2;
            we = 1; addr = 2'b01; data_in = 4'h4; @(posedge clk); #2;
            we = 1; addr = 2'b10; data_in = 4'h8; @(posedge clk); #2;
            we = 1; addr = 2'b11; data_in = 4'hC; @(posedge clk); #2;


            we = 0; addr = 2'b10;
            #2;

            #1;


            check_outputs(4'h8);
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
        $dumpvars(0,addr, clk, data_in, we, data_out);
    end

endmodule
