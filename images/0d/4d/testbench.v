`timescale 1ns/1ps

module nat_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] ipv4_in;
    reg [15:0] port_in;
    reg reset;
    wire [31:0] ipv4_out;
    wire [15:0] port_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat dut (
        .clk(clk),
        .ipv4_in(ipv4_in),
        .port_in(port_in),
        .reset(reset),
        .ipv4_out(ipv4_out),
        .port_out(port_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ipv4_in = 32'h0;
            port_in = 16'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Translation (10.0.0.1:80)", test_num);
            reset_dut();

            ipv4_in = {8'd10, 8'd0, 8'd0, 8'd1};
            port_in = 16'd80;


            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hC0000001, 16'd1080, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Port Rollover Check (Port 65000)", test_num);
            reset_dut();

            ipv4_in = {8'd172, 8'd16, 8'd50, 8'd4};
            port_in = 16'd65000;

            @(posedge clk);
            #1;



            #1;




            check_outputs(32'hC0103204, 16'd464, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Port and Min IP Octets", test_num);
            reset_dut();

            ipv4_in = {8'd1, 8'd0, 8'd0, 8'd0};
            port_in = 16'd0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hC0000000, 16'd1000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input IP already starts with 192", test_num);
            reset_dut();

            ipv4_in = {8'd192, 8'd168, 8'd1, 8'd100};
            port_in = 16'd5000;

            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hC0A80164, 16'd6000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum IP Octets", test_num);
            reset_dut();

            ipv4_in = 32'hFFFFFFFF;
            port_in = 16'd1234;

            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hC0FFFFFF, 16'd2234, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat Testbench");
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
        input [31:0] expected_ipv4_out;
        input [15:0] expected_port_out;
        input expected_valid;
        begin
            if (expected_ipv4_out === (expected_ipv4_out ^ ipv4_out ^ expected_ipv4_out) &&
                expected_port_out === (expected_port_out ^ port_out ^ expected_port_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: ipv4_out=%h, port_out=%h, valid=%b",
                         ipv4_out, port_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ipv4_out=%h, port_out=%h, valid=%b",
                         expected_ipv4_out, expected_port_out, expected_valid);
                $display("  Got:      ipv4_out=%h, port_out=%h, valid=%b",
                         ipv4_out, port_out, valid);
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
        $dumpvars(0,clk, ipv4_in, port_in, reset, ipv4_out, port_out, valid);
    end

endmodule
