`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg clk;
    reg [15:0] data_in;
    reg [15:0] mem_address_in;
    reg rst;
    wire [15:0] data_out;
    wire [15:0] mem_address_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in(data_in),
        .mem_address_in(mem_address_in),
        .rst(rst),
        .data_out(data_out),
        .mem_address_out(mem_address_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            channel_select = 0;
            data_in = 0;
            mem_address_in = 0;
            repeat (2) @(posedge clk);
            rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Channel 0", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 2'b00;
            data_in = 16'hAAAA;
            mem_address_in = 16'h1000;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(16'hAAAA, 16'h1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Channel 1", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 2'b01;
            data_in = 16'hBBBB;
            mem_address_in = 16'h2000;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(16'hBBBB, 16'h2000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Channel 2", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 2'b10;
            data_in = 16'hCCCC;
            mem_address_in = 16'h3000;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(16'hCCCC, 16'h3000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Channel 3", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 2'b11;
            data_in = 16'hDDDD;
            mem_address_in = 16'h4000;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(16'hDDDD, 16'h4000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Switch Select from Ch0 to Ch3", test_num);
            reset_dut();


            @(posedge clk);
            channel_select = 2'b00;
            data_in = 16'h1111;
            mem_address_in = 16'h0101;


            @(posedge clk);
            channel_select = 2'b11;
            data_in = 16'hEFEF;
            mem_address_in = 16'h8888;

            repeat (2) @(posedge clk);


            #1;



            check_outputs(16'hEFEF, 16'h8888);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Behavior Verification", test_num);


            @(posedge clk);
            channel_select = 2'b01;
            data_in = 16'hFFFF;
            mem_address_in = 16'hFFFF;


            rst = 1;
            repeat (2) @(posedge clk);
            rst = 0;
            @(posedge clk);


            #1;



            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Values on Channel 2", test_num);
            reset_dut();

            @(posedge clk);
            channel_select = 2'b10;
            data_in = 16'hFFFF;
            mem_address_in = 16'hFFFF;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(16'hFFFF, 16'hFFFF);
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
        input [15:0] expected_data_out;
        input [15:0] expected_mem_address_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_mem_address_out === (expected_mem_address_out ^ mem_address_out ^ expected_mem_address_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, mem_address_out=%h",
                         data_out, mem_address_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, mem_address_out=%h",
                         expected_data_out, expected_mem_address_out);
                $display("  Got:      data_out=%h, mem_address_out=%h",
                         data_out, mem_address_out);
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
        $dumpvars(0,channel_select, clk, data_in, mem_address_in, rst, data_out, mem_address_out);
    end

endmodule
