`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg req;
    reg rst;
    wire ack;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .data_in(data_in),
        .req(req),
        .rst(rst),
        .ack(ack),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        req = 0;
        data_in = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic single data transfer", test_num);
        reset_dut();

        data_in = 32'h12345678;
        req = 1;


        wait(ack == 1);


        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 32'h12345678);
        req = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Transfer with a different data pattern", test_num);
        reset_dut();

        data_in = 32'hDEADBEEF;
        req = 1;

        wait(ack == 1);
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 32'hDEADBEEF);
        req = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verify no transfer occurs without req signal", test_num);
        reset_dut();

        data_in = 32'hFFFFFFFF;
        req = 0;

        repeat(5) @(posedge clk);
        #1;


        #1;



        check_outputs(1'b0, 32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verify reset clears outputs", test_num);
        reset_dut();


        data_in = 32'hAAAA5555;
        req = 1;
        wait(ack == 1);
        @(posedge clk);


        rst = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b0, 32'h00000000);
        rst = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Consecutive transfers", test_num);
        reset_dut();


        data_in = 32'h11111111;
        req = 1;
        wait(ack == 1);
        @(posedge clk);


        data_in = 32'h22222222;
        req = 1;
        wait(ack == 1);
        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b1, 32'h22222222);
        req = 0;
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
        input expected_ack;
        input [31:0] expected_data_out;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h",
                         ack, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h",
                         expected_ack, expected_data_out);
                $display("  Got:      ack=%b, data_out=%h",
                         ack, data_out);
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
        $dumpvars(0,clk, data_in, req, rst, ack, data_out);
    end

endmodule
