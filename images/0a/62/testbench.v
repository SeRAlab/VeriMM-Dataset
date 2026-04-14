`timescale 1ns/1ps

module vmu_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg valid;
    reg [1:0] virtual_page;
    wire error;
    wire [3:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vmu dut (
        .clk(clk),
        .valid(valid),
        .virtual_page(virtual_page),
        .error(error),
        .physical_address(physical_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            valid = 0;
            virtual_page = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Translate Virtual Page 0 (Valid)", test_num);
            reset_dut();

            virtual_page = 2'b00;
            valid = 1'b1;


            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Translate Virtual Page 1 (Valid)", test_num);
            reset_dut();

            virtual_page = 2'b01;
            valid = 1'b1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Translate Virtual Page 2 (Valid)", test_num);
            reset_dut();

            virtual_page = 2'b10;
            valid = 1'b1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 4'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Translate Virtual Page 3 (Valid)", test_num);
            reset_dut();

            virtual_page = 2'b11;
            valid = 1'b1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Invalid Access for Page 0", test_num);
            reset_dut();

            virtual_page = 2'b00;
            valid = 1'b0;

            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Sequential Logic Verification", test_num);
            reset_dut();


            virtual_page = 2'b10;
            valid = 1'b1;
            @(posedge clk);
            #1;


            virtual_page = 2'b10;
            valid = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vmu Testbench");
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
        input expected_error;
        input [3:0] expected_physical_address;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address)) begin
                $display("PASS");
                $display("  Outputs: error=%b, physical_address=%h",
                         error, physical_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, physical_address=%h",
                         expected_error, expected_physical_address);
                $display("  Got:      error=%b, physical_address=%h",
                         error, physical_address);
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
        $dumpvars(0,clk, valid, virtual_page, error, physical_address);
    end

endmodule
