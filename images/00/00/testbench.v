`timescale 1ns/1ps

module pcie_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg request;
    reg [7:0] request_data;
    reg rst_n;
    wire response;
    wire response_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_controller dut (
        .clk(clk),
        .request(request),
        .request_data(request_data),
        .rst_n(rst_n),
        .response(response),
        .response_data(response_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        request = 0;
        request_data = 8'h00;
        #20;
        rst_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase %0d: Basic Successful Request (Data: 0xA5)", test_num);

        request = 1;
        request_data = 8'hA5;
        @(posedge clk);
        request = 0;
        request_data = 8'h00;


        repeat(3) @(posedge clk);


        #1;



        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase %0d: Invalid Request (Data: 0x00)", test_num);

        request = 1;
        request_data = 8'h00;
        @(posedge clk);
        request = 0;

        repeat(3) @(posedge clk);


        #1;



        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase %0d: Max Data Request (Data: 0xFF)", test_num);

        request = 1;
        request_data = 8'hFF;
        @(posedge clk);
        request = 0;

        repeat(3) @(posedge clk);


        #1;



        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase %0d: Idle State (No Request)", test_num);

        request = 0;
        repeat(5) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase %0d: Reset Mid-Operation", test_num);

        request = 1;
        request_data = 8'hA5;
        @(posedge clk);
        request = 0;


        @(posedge clk);
        rst_n = 0;
        #10;
        rst_n = 1;

        repeat(3) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_controller Testbench");
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
        input expected_response;
        input expected_response_data;
        begin
            if (expected_response === (expected_response ^ response ^ expected_response) &&
                expected_response_data === (expected_response_data ^ response_data ^ expected_response_data)) begin
                $display("PASS");
                $display("  Outputs: response=%b, response_data=%b",
                         response, response_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: response=%b, response_data=%b",
                         expected_response, expected_response_data);
                $display("  Got:      response=%b, response_data=%b",
                         response, response_data);
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
        $dumpvars(0,clk, request, request_data, rst_n, response, response_data);
    end

endmodule
