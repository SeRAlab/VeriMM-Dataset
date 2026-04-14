`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data1;
    reg [31:0] data2;
    reg sel;
    wire [31:0] forwarded_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .data1(data1),
        .data2(data2),
        .sel(sel),
        .forwarded_data(forwarded_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data1 (sel=0)", test_num);
            data1 = 32'hAAAAAAAA;
            data2 = 32'h55555555;
            sel = 0;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data2 (sel=1)", test_num);
            data1 = 32'hAAAAAAAA;
            data2 = 32'h55555555;
            sel = 1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data1 with all ones", test_num);
            data1 = 32'hFFFFFFFF;
            data2 = 32'h00000000;
            sel = 0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data2 with all zeros", test_num);
            data1 = 32'hFFFFFFFF;
            data2 = 32'h00000000;
            sel = 1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data1 (random hex values)", test_num);
            data1 = 32'h12345678;
            data2 = 32'hFEDCBA98;
            sel = 0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data2 (random hex values)", test_num);
            data1 = 32'hDEADBEEF;
            data2 = 32'hCAFEBABE;
            sel = 1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit patterns data1", test_num);
            data1 = 32'h3333CCCC;
            data2 = 32'h66669999;
            sel = 0;
            #1;

            check_outputs(32'h3333CCCC);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit patterns data2", test_num);
            data1 = 32'h3333CCCC;
            data2 = 32'h66669999;
            sel = 1;
            #1;

            check_outputs(32'h66669999);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_unit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [31:0] expected_forwarded_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwarded_data === (expected_forwarded_data ^ forwarded_data ^ expected_forwarded_data)) begin
                $display("PASS");
                $display("  Outputs: forwarded_data=%h",
                         forwarded_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwarded_data=%h",
                         expected_forwarded_data);
                $display("  Got:      forwarded_data=%h",
                         forwarded_data);
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
