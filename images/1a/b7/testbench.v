`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [3:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .clk(clk),
        .data_in(data_in),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        data_in = 4'b0;
        read_enable = 0;
        write_enable = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Write and Read", test_num);
        reset_dut();


        data_in = 4'hA;
        write_enable = 1;
        @(posedge clk);
        #1;
        write_enable = 0;


        read_enable = 1;
        #2;
        #1;

        check_outputs(4'hA, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Write Enable Low Check", test_num);
        reset_dut();


        data_in = 4'h5;
        write_enable = 1;
        @(posedge clk);
        #1;


        data_in = 4'hF;
        write_enable = 0;
        @(posedge clk);
        #1;


        read_enable = 1;
        #2;
        #1;

        check_outputs(4'h5, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Read Enable Low Check", test_num);
        reset_dut();


        data_in = 4'hC;
        write_enable = 1;
        @(posedge clk);
        #1;
        write_enable = 0;


        read_enable = 0;
        #2;


        #1;



        check_outputs(data_out, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Successive Writes", test_num);
        reset_dut();


        data_in = 4'h1;
        write_enable = 1;
        @(posedge clk);
        #1;


        data_in = 4'hE;
        write_enable = 1;
        @(posedge clk);
        #1;
        write_enable = 0;


        read_enable = 1;
        #2;
        #1;

        check_outputs(4'hE, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Bits (4'hF then 4'h0)", test_num);
        reset_dut();


        data_in = 4'hF;
        write_enable = 1;
        @(posedge clk);
        #1;
        write_enable = 0;
        read_enable = 1;
        #2;
        if (data_out !== 4'hF || valid !== 1'b1) begin
            #1;

            check_outputs(4'hF, 1'b1);
        end else begin

            read_enable = 0;
            data_in = 4'h0;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;
            read_enable = 1;
            #2;
            #1;

            check_outputs(4'h0, 1'b1);
        end
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
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, data_in, read_enable, write_enable, data_out, valid);
    end

endmodule
