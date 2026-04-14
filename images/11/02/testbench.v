`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr1;
    reg [7:0] addr2;
    reg clk;
    reg [15:0] data_in1;
    reg [15:0] data_in2;
    reg req1;
    reg req2;
    reg rst_n;
    wire [15:0] data_out1;
    wire [15:0] data_out2;
    wire gnt1;
    wire gnt2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .req1(req1),
        .req2(req2),
        .rst_n(rst_n),
        .data_out1(data_out1),
        .data_out2(data_out2),
        .gnt1(gnt1),
        .gnt2(gnt2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            req1 = 0;
            req2 = 0;
            addr1 = 0;
            addr2 = 0;
            data_in1 = 0;
            data_in2 = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Post-Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Channel 1 Transfer Request", test_num);
            reset_dut();

            @(posedge clk);
            req1 = 1;
            addr1 = 8'hA0;
            data_in1 = 16'h1234;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234, 16'h0000, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Channel 2 Transfer Request", test_num);
            reset_dut();

            @(posedge clk);
            req2 = 1;
            addr2 = 8'hB0;
            data_in2 = 16'hABCD;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'hABCD, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Simultaneous Channel 1 & 2 Requests", test_num);
            reset_dut();

            @(posedge clk);
            req1 = 1;
            req2 = 1;
            addr1 = 8'h01;
            addr2 = 8'h02;
            data_in1 = 16'hAAAA;
            data_in2 = 16'hBBBB;

            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA, 16'hBBBB, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: De-asserting Requests", test_num);
            reset_dut();


            @(posedge clk);
            req1 = 1;
            data_in1 = 16'h5555;
            @(posedge clk);


            @(posedge clk);
            req1 = 0;
            addr1 = 8'h00;
            data_in1 = 16'h0000;

            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000, 16'h0000, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Dynamic Data Update", test_num);
            reset_dut();

            @(posedge clk);
            req1 = 1;
            data_in1 = 16'h1111;
            @(posedge clk);


            data_in1 = 16'h2222;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2222, 16'h0000, 1'b1, 1'b0);
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
        input [15:0] expected_data_out1;
        input [15:0] expected_data_out2;
        input expected_gnt1;
        input expected_gnt2;
        begin
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2) &&
                expected_gnt1 === (expected_gnt1 ^ gnt1 ^ expected_gnt1) &&
                expected_gnt2 === (expected_gnt2 ^ gnt2 ^ expected_gnt2)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h, gnt1=%b, gnt2=%b",
                         data_out1, data_out2, gnt1, gnt2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h, gnt1=%b, gnt2=%b",
                         expected_data_out1, expected_data_out2, expected_gnt1, expected_gnt2);
                $display("  Got:      data_out1=%h, data_out2=%h, gnt1=%b, gnt2=%b",
                         data_out1, data_out2, gnt1, gnt2);
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
        $dumpvars(0,addr1, addr2, clk, data_in1, data_in2, req1, req2, rst_n, data_out1, data_out2, gnt1, gnt2);
    end

endmodule
