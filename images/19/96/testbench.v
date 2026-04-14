`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg req;
    reg [7:0] src_addr;
    wire [7:0] data;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .req(req),
        .src_addr(src_addr),
        .data(data),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            req <= 0;
            src_addr <= 8'h00;
            dest_addr <= 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Transfer 0x10 -> 0x20", test_num);
            reset_dut();

            src_addr <= 8'h10;
            dest_addr <= 8'h20;
            req <= 1;



            @(posedge clk);
            #1;
            wait(done === 1'b1);



            #1;




            check_outputs(8'h10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transfer 0xAA -> 0xBB", test_num);
            reset_dut();

            src_addr <= 8'hAA;
            dest_addr <= 8'hBB;
            req <= 1;

            @(posedge clk);
            #1;
            wait(done === 1'b1);

            #1;


            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Idle state (No request)", test_num);
            reset_dut();

            src_addr <= 8'h55;
            dest_addr <= 8'h66;
            req <= 0;


            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive Transfer Clear", test_num);
            reset_dut();


            src_addr <= 8'h01;
            dest_addr <= 8'h02;
            req <= 1;
            @(posedge clk);
            wait(done === 1'b1);


            #1;
            req <= 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address 0xFF -> 0x00", test_num);
            reset_dut();

            src_addr <= 8'hFF;
            dest_addr <= 8'h00;
            req <= 1;

            @(posedge clk);
            #1;
            wait(done === 1'b1);

            #1;


            check_outputs(8'hFF, 1'b1);
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
        input [7:0] expected_data;
        input expected_done;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data=%h, done=%b",
                         data, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, done=%b",
                         expected_data, expected_done);
                $display("  Got:      data=%h, done=%b",
                         data, done);
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
        $dumpvars(0,clk, dest_addr, req, src_addr, data, done);
    end

endmodule
