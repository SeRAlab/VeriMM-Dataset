`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg read_request;
    reg reset;
    reg write_request;
    wire [31:0] data_out;
    wire read_ready;
    wire write_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .data_in(data_in),
        .read_request(read_request),
        .reset(reset),
        .write_request(write_request),
        .data_out(data_out),
        .read_ready(read_ready),
        .write_ready(write_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        data_in = 32'h0;
        read_request = 0;
        write_request = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(32'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        data_in = 32'hABCD_1234;
        write_request = 1;
        @(posedge clk);
        #1 write_request = 0;


        repeat(2) @(posedge clk);
        #1;



        #1;




        check_outputs(32'h0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();


        data_in = 32'h55AA_EEFF;
        write_request = 1;
        @(posedge clk);
        #1 write_request = 0;
        repeat(2) @(posedge clk);


        read_request = 1;
        @(posedge clk);
        #1 read_request = 0;
        repeat(2) @(posedge clk);
        #1;


        #1;



        check_outputs(32'h55AA_EEFF, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();


        data_in = 32'h1111_1111;
        write_request = 1;
        @(posedge clk);
        #1 write_request = 0;
        @(posedge clk);


        data_in = 32'h2222_2222;
        write_request = 1;
        @(posedge clk);
        #1 write_request = 0;
        repeat(2) @(posedge clk);


        read_request = 1;
        @(posedge clk);
        #1 read_request = 0;
        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(32'h2222_2222, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        data_in = 32'h9988_7766;
        write_request = 1;
        read_request = 1;
        @(posedge clk);
        #1;
        write_request = 0;
        read_request = 0;

        repeat(3) @(posedge clk);
        #1;


        #1;



        check_outputs(32'h9988_7766, 1'b1, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        input [31:0] expected_data_out;
        input expected_read_ready;
        input expected_write_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_read_ready === (expected_read_ready ^ read_ready ^ expected_read_ready) &&
                expected_write_ready === (expected_write_ready ^ write_ready ^ expected_write_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, read_ready=%b, write_ready=%b",
                         data_out, read_ready, write_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, read_ready=%b, write_ready=%b",
                         expected_data_out, expected_read_ready, expected_write_ready);
                $display("  Got:      data_out=%h, read_ready=%b, write_ready=%b",
                         data_out, read_ready, write_ready);
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
        $dumpvars(0,clk, data_in, read_request, reset, write_request, data_out, read_ready, write_ready);
    end

endmodule
