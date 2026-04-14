`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addr;
    reg clk;
    reg read_req;
    reg rst_n;
    wire [7:0] data_out;
    wire data_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .addr(addr),
        .clk(clk),
        .read_req(read_req),
        .rst_n(rst_n),
        .data_out(data_out),
        .data_ready(data_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            read_req = 0;
            addr = 0;
            #20;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Read from address 5'h05", test_num);
            reset_dut();


            addr = 5'h05;
            read_req = 1;
            @(posedge clk);
            read_req = 0;



            repeat(2) @(posedge clk);


            #1;

            #1;


            check_outputs(8'h05, 1'b1);


            @(posedge clk);
            #1;
            if (data_ready !== 1'b0) begin
                $display("  FAIL: Controller did not return to IDLE (data_ready still high)");
            end
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Read from boundary address 5'h00", test_num);
            reset_dut();

            addr = 5'h00;
            read_req = 1;
            @(posedge clk);
            read_req = 0;


            while (data_ready !== 1'b1) @(posedge clk);

            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Read from boundary address 5'h1F", test_num);
            reset_dut();

            addr = 5'h1F;
            read_req = 1;
            @(posedge clk);
            read_req = 0;


            while (data_ready !== 1'b1) @(posedge clk);

            #1;
            #1;

            check_outputs(8'h1F, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Read from address 5'h12", test_num);
            reset_dut();

            addr = 5'h12;
            read_req = 1;
            @(posedge clk);
            read_req = 0;


            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'h12, 1'b1);


            @(posedge clk);
            #1;
            if (data_ready === 1'b0) begin
                $display("  INFO: Controller successfully returned to IDLE");
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
        $display("pcie_endpoint_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [7:0] expected_data_out;
        input expected_data_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_ready=%b",
                         data_out, data_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_ready=%b",
                         expected_data_out, expected_data_ready);
                $display("  Got:      data_out=%h, data_ready=%b",
                         data_out, data_ready);
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
        $dumpvars(0,addr, clk, read_req, rst_n, data_out, data_ready);
    end

endmodule
