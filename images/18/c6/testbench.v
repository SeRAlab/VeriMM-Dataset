`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg clk;
    reg request;
    wire [2:0] mem_address;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .request(request),
        .mem_address(mem_address),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            channel_select = 2'b00;
            request = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 0 Request", test_num);
            reset_dut();
            channel_select = 2'b00;
            request = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 1 Request", test_num);
            reset_dut();
            channel_select = 2'b01;
            request = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 2 Request", test_num);
            reset_dut();
            channel_select = 2'b10;
            request = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 3 Request", test_num);
            reset_dut();
            channel_select = 2'b11;
            request = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No Request", test_num);
            reset_dut();
            channel_select = 2'b00;
            request = 1'b0;
            @(posedge clk);
            #1;

            if (valid === 1'b0) begin
                $display("PASS: Valid is 0 as expected");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Valid should be 0 when request is low");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive Requests (CH0 then CH1)", test_num);
            reset_dut();


            channel_select = 2'b00;
            request = 1'b1;
            @(posedge clk);
            #1;


            channel_select = 2'b01;
            request = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b001, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Wrap-around Requests (CH3 then CH0)", test_num);
            reset_dut();


            channel_select = 2'b11;
            request = 1'b1;
            @(posedge clk);
            #1;


            channel_select = 2'b00;
            request = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [2:0] expected_mem_address;
        input expected_valid;
        begin
            if (expected_mem_address === (expected_mem_address ^ mem_address ^ expected_mem_address) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: mem_address=%h, valid=%b",
                         mem_address, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_address=%h, valid=%b",
                         expected_mem_address, expected_valid);
                $display("  Got:      mem_address=%h, valid=%b",
                         mem_address, valid);
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
        $dumpvars(0,channel_select, clk, request, mem_address, valid);
    end

endmodule
