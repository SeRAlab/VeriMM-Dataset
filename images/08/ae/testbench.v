`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] addr;
    reg [15:0] data_in;
    reg read;
    reg write;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .addr(addr),
        .data_in(data_in),
        .read(read),
        .write(write),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Write and Read at Address 0", test_num);

            addr = 4'h0; data_in = 16'h0000; write = 0; read = 0;
            #10;

            addr = 4'h0; data_in = 16'hAAAA; write = 1; read = 0;
            #10;

            write = 0; read = 1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Write and Read at Address 15", test_num);

            addr = 4'h0; data_in = 16'h0000; write = 0; read = 0;
            #10;

            addr = 4'hF; data_in = 16'h5555; write = 1; read = 0;
            #10;

            write = 0; read = 1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overwrite Data at Address 5", test_num);

            addr = 4'h0; data_in = 16'h0000; write = 0; read = 0;
            #10;

            addr = 4'h5; data_in = 16'h1111; write = 1; read = 0;
            #10;

            data_in = 16'hEEEE;
            #10;

            write = 0; read = 1;
            #1;

            check_outputs(16'hEEEE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Independence (Multiple Addresses)", test_num);

            addr = 4'h0; data_in = 16'h0000; write = 0; read = 0;
            #10;

            addr = 4'h2; data_in = 16'hBEEF; write = 1;
            #10;

            addr = 4'h3; data_in = 16'hCAFE; write = 1;
            #10;

            write = 0; addr = 4'h2; read = 1;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Write Enable logic", test_num);

            addr = 4'h8; data_in = 16'h0000; write = 0; read = 0;
            #10;

            addr = 4'h8; data_in = 16'h1234; write = 0;
            #10;

            addr = 4'h8; data_in = 16'h9999; write = 1;
            #10;

            write = 0; data_in = 16'h4321;
            #10;

            read = 1;
            #1;

            check_outputs(16'h9999);
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
