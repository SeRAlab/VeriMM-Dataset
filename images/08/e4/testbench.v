`timescale 1ns/1ps

module nvme_read_controller_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] address;
    reg clk;
    reg rst;
    reg start_read;
    wire [31:0] data_out;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_read_controller dut (
        .address(address),
        .clk(clk),
        .rst(rst),
        .start_read(start_read),
        .data_out(data_out),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            address = 16'h0;
            start_read = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Read Operation", test_num);
            reset_dut();


            address = 16'h1001;
            start_read = 1;
            @(posedge clk);
            start_read = 0;



            fork : timeout_001
                begin
                    wait(status == 1'b1);
                end
                begin
                    repeat(20) @(posedge clk);
                end
            join_any
            disable timeout_001;


            #1;




            #1;





            check_outputs(32'h00001001, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read from Address 0xAAAA", test_num);
            reset_dut();

            address = 16'hAAAA;
            start_read = 1;
            @(posedge clk);
            start_read = 0;

            fork : timeout_002
                begin
                    wait(status == 1'b1);
                end
                begin
                    repeat(20) @(posedge clk);
                end
            join_any
            disable timeout_002;

            #1;
            #1;

            check_outputs(32'h0000AAAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Idle State Check", test_num);
            reset_dut();


            repeat(5) @(posedge clk);


            #1;



            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read from Address 0x0000", test_num);
            reset_dut();

            address = 16'h0000;
            start_read = 1;
            @(posedge clk);
            start_read = 0;

            fork : timeout_004
                begin
                    wait(status == 1'b1);
                end
                begin
                    repeat(20) @(posedge clk);
                end
            join_any
            disable timeout_004;

            #1;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Recovery Check", test_num);
            reset_dut();


            address = 16'h5555;
            start_read = 1;
            @(posedge clk);
            start_read = 0;


            @(posedge clk);


            rst = 1;
            repeat(2) @(posedge clk);
            rst = 0;
            repeat(1) @(posedge clk);


            #1;



            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_read_controller Testbench");
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
        input expected_status;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, status=%b",
                         data_out, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, status=%b",
                         expected_data_out, expected_status);
                $display("  Got:      data_out=%h, status=%b",
                         data_out, status);
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
        $dumpvars(0,address, clk, rst, start_read, data_out, status);
    end

endmodule
