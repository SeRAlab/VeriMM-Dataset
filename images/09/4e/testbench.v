`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    reg re;
    reg we;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .data(data),
        .re(re),
        .we(we),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write 0xAA and Read", test_num);

            we = 0; re = 0; data = 0;
            #10;


            we = 1; data = 8'hAA;
            #10;
            we = 0;


            re = 1;
            #1;

            check_outputs(8'hAA);
            re = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write 0x55 and Read", test_num);

            we = 0; re = 0; data = 0;
            #10;


            we = 1; data = 8'h55;
            #10;
            we = 0;


            re = 1;
            #1;

            check_outputs(8'h55);
            re = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable (we=0) Check", test_num);

            we = 0; re = 0; data = 0;
            #10;


            we = 0; data = 8'hFF;
            #10;


            re = 1;
            #1;

            check_outputs(8'h55);
            re = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Value Write (0xFF)", test_num);

            we = 0; re = 0; data = 0;
            #10;


            we = 1; data = 8'hFF;
            #10;
            we = 0;


            re = 1;
            #1;

            check_outputs(8'hFF);
            re = 0;


            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Value Write (0x00)", test_num);
            we = 1; data = 8'h00;
            #10;
            we = 0;
            re = 1;
            #1;

            check_outputs(8'h00);
            re = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);

            we = 0; re = 0; data = 0;
            #10;


            we = 1; re = 1; data = 8'h12;
            #10;


            #1;



            check_outputs(8'h12);


            we = 0; re = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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

endmodule
