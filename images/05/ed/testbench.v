`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg read_en;
    reg write_en;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .data_in(data_in),
        .read_en(read_en),
        .write_en(write_en),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write and Read 0xAAAA", test_num);

            data_in = 16'hAAAA;
            write_en = 1;
            read_en = 0;
            #10;

            write_en = 0;
            read_en = 1;
            #10;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write and Read 0x5555", test_num);

            data_in = 16'h5555;
            write_en = 1;
            read_en = 0;
            #10;

            write_en = 0;
            read_en = 1;
            #10;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write and Read 0xFFFF", test_num);
            data_in = 16'hFFFF;
            write_en = 1;
            read_en = 0;
            #10;
            write_en = 0;
            read_en = 1;
            #10;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write and Read 0x0000", test_num);
            data_in = 16'h0000;
            write_en = 1;
            read_en = 0;
            #10;
            write_en = 0;
            read_en = 1;
            #10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Persistence Check", test_num);

            data_in = 16'h1234;
            write_en = 1;
            read_en = 0;
            #10;

            write_en = 0;
            read_en = 0;
            data_in = 16'hFFFF;
            #20;

            read_en = 1;
            #10;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous Write and Read", test_num);
            data_in = 16'hBEEF;
            write_en = 1;
            read_en = 1;
            #10;

            #1;


            check_outputs(16'hBEEF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Output Disable Check (read_en=0)", test_num);

            data_in = 16'h7777;
            write_en = 1;
            read_en = 0;
            #10;
            write_en = 0;



            #1;




            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
