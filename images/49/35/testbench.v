`timescale 1ns/1ps

module width_8to16_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    reg valid_in;
    wire [15:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    width_8to16 dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        valid_in = 0;
        data_in = 8'h0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic 2-byte consecutive conversion", test_num);
        reset_dut();

        @(posedge clk);
        valid_in = 1; data_in = 8'hAB;
        @(posedge clk);
        valid_in = 1; data_in = 8'hCD;
        @(posedge clk);
        valid_in = 0; data_in = 8'h00;


        @(posedge clk);
        #1 #1;
 check_outputs(16'hABCD, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Conversion with gaps between input bytes", test_num);
        reset_dut();

        @(posedge clk);
        valid_in = 1; data_in = 8'h12;
        @(posedge clk);
        valid_in = 0; data_in = 8'hFF;
        repeat(3) @(posedge clk);

        valid_in = 1; data_in = 8'h34;
        @(posedge clk);
        valid_in = 0;

        @(posedge clk);
        #1 #1;
 check_outputs(16'h1234, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Back-to-back stream of pairs", test_num);
        reset_dut();

        @(posedge clk);
        valid_in = 1; data_in = 8'h11;
        @(posedge clk);
        valid_in = 1; data_in = 8'h22;
        @(posedge clk);
        valid_in = 1; data_in = 8'h33;
        @(posedge clk);
        valid_in = 1; data_in = 8'h44;
        @(posedge clk);
        valid_in = 0;


        repeat(1) @(posedge clk);
        #1 #1;
 check_outputs(16'h3344, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Reset after only one byte received", test_num);
        reset_dut();

        @(posedge clk);
        valid_in = 1; data_in = 8'hEE;
        @(posedge clk);
        valid_in = 0;


        rst_n = 0;
        #10 rst_n = 1;
        repeat(1) @(posedge clk);


        @(posedge clk);
        valid_in = 1; data_in = 8'h55;
        @(posedge clk);
        valid_in = 1; data_in = 8'h66;
        @(posedge clk);
        valid_in = 0;

        @(posedge clk);

        #1 #1;
 check_outputs(16'h5566, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Boundary values (0x00 and 0xFF)", test_num);
        reset_dut();

        @(posedge clk);
        valid_in = 1; data_in = 8'hFF;
        @(posedge clk);
        valid_in = 1; data_in = 8'h00;
        @(posedge clk);
        valid_in = 0;

        @(posedge clk);
        #1 #1;
 check_outputs(16'hFF00, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("width_8to16 Testbench");
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
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data_in, rst_n, valid_in, data_out, valid_out);
    end

endmodule
