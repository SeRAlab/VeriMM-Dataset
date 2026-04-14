`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg req;
    reg rst_n;
    wire ack;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .addr(addr),
        .clk(clk),
        .req(req),
        .rst_n(rst_n),
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
            rst_n = 0;
            req = 0;
            addr = 0;
            #20;
            @(posedge clk);
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Basic Read (Addr: 0x12345678)", test_num);
            reset_dut();


            @(posedge clk);
            req <= 1;
            addr <= 32'h12345678;


            @(posedge clk);
            req <= 0;
            addr <= 32'h0;



            repeat(3) @(posedge clk);


            #1;
            #1;

            check_outputs(1'b1, 32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Basic Read (Addr: 0xABCDEF00)", test_num);
            reset_dut();

            @(posedge clk);
            req <= 1;
            addr <= 32'hABCDEF00;

            @(posedge clk);
            req <= 0;
            addr <= 32'h0;

            repeat(3) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 32'hABCDEF00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Idle State Check", test_num);
            reset_dut();


            repeat(10) @(posedge clk);

            #1;


            #1;



            check_outputs(1'b0, data_out);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Maximum Address (0xFFFFFFFF)", test_num);
            reset_dut();

            @(posedge clk);
            req <= 1;
            addr <= 32'hFFFFFFFF;

            @(posedge clk);
            req <= 0;

            repeat(3) @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Reset during wait period", test_num);
            reset_dut();

            @(posedge clk);
            req <= 1;
            addr <= 32'h5555AAAA;

            @(posedge clk);
            req <= 0;


            repeat(2) @(posedge clk);
            rst_n <= 0;
            repeat(2) @(posedge clk);
            rst_n <= 1;

            #1;

            #1;


            check_outputs(1'b0, 0);
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
        $dumpvars(0,addr, clk, req, rst_n, ack, data_out);
    end

endmodule
